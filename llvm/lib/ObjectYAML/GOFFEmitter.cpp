//===- yaml2goff - Convert YAML to a GOFF object file ---------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
///
/// \file
/// The GOFF component of yaml2obj.
///
//===----------------------------------------------------------------------===//

#include "llvm/BinaryFormat/GOFF.h"
#include "llvm/ObjectYAML/GOFFYAML.h"
#include "llvm/ObjectYAML/yaml2obj.h"
#include "llvm/Support/ConvertEBCDIC.h"
#include "llvm/Support/Endian.h"
#include "llvm/Support/ErrorHandling.h"
#include "llvm/Support/raw_ostream.h"

using namespace llvm;

namespace {

// Common flag values on records.
enum {
  // Flag: This record is continued.
  Rec_Continued = 1 << 0,

  // Flag: This record is a continuation.
  Rec_Continuation = 1 << 1,
};

template <typename ValueType> struct BinaryBeImpl {
  ValueType Value;
  BinaryBeImpl(ValueType V) : Value(V) {}
};

template <typename ValueType>
raw_ostream &operator<<(raw_ostream &OS, const BinaryBeImpl<ValueType> &BBE) {
  char Buffer[sizeof(BBE.Value)];
  support::endian::write<ValueType, llvm::endianness::big, support::unaligned>(
      Buffer, BBE.Value);
  OS.write(Buffer, sizeof(BBE.Value));
  return OS;
}

template <typename ValueType> BinaryBeImpl<ValueType> binaryBe(ValueType V) {
  return BinaryBeImpl<ValueType>(V);
}

struct ZerosImpl {
  size_t NumBytes;
};

raw_ostream &operator<<(raw_ostream &OS, const ZerosImpl &Z) {
  OS.write_zeros(Z.NumBytes);
  return OS;
}

ZerosImpl zeros(const size_t NumBytes) { return ZerosImpl{NumBytes}; }

// The GOFFOstream is responsible to write the data into the fixed physical
// records of the format. A user of this class announces the start of a new
// logical record, and writes the full logical block. The physical records are
// created while the content is written to the underlying stream. Possible fill
// bytes at the end of a physical record are written automatically.
// The implementation aims at simplicity, not speed.
class GOFFOStream {
public:
  explicit GOFFOStream(raw_ostream &OS) : OS(OS), CurrentType() {}

  GOFFOStream &operator<<(StringRef Str) {
    write(Str);
    return *this;
  }

  void newRecord(GOFF::RecordType Type) { CurrentType = Type; }

private:
  // The underlying raw_ostream.
  raw_ostream &OS;

  // The type of the current (logical) record.
  GOFF::RecordType CurrentType;

  // Write the record prefix of a physical record, using the current record
  // type.
  void writeRecordPrefix(uint8_t Flags);

  // Write a logical record.
  void write(StringRef Str);
};

void GOFFOStream::writeRecordPrefix(uint8_t Flags) {
  // See https://www.ibm.com/docs/en/zos/3.1.0?topic=conventions-record-prefix.
  uint8_t TypeAndFlags = Flags | (CurrentType << 4);
  OS << binaryBe(uint8_t(GOFF::PTVPrefix)) // The prefix value.
     << binaryBe(uint8_t(TypeAndFlags))    // The record type and the flags.
     << binaryBe(uint8_t(0));              // The version.
}

void GOFFOStream::write(StringRef Str) {
  // The flags are determined by the flags of the prvious record, and by the
  // size of the remaining data.
  size_t Pos = 0;
  size_t Size = Str.size();
  bool Continuation = false;
  while (Size > 0) {
    uint8_t Flags = 0;
    if (Continuation)
      Flags |= Rec_Continuation;
    if (Size > GOFF::RecordContentLength) {
      Flags |= Rec_Continued;
      Continuation = true;
    }
    writeRecordPrefix(Flags);
    if (Size < GOFF::RecordContentLength) {
      OS.write(&Str.data()[Pos], Size);
      OS.write_zeros(GOFF::RecordContentLength - Size);
      Size = 0;
    } else {
      OS.write(&Str.data()[Pos], GOFF::RecordContentLength);
      Size -= GOFF::RecordContentLength;
    }
    Pos += GOFF::RecordContentLength;
  }
}

// A LogicalRecord buffers the data of a record.
class LogicalRecord : public raw_svector_ostream {
  GOFFOStream &OS;
  SmallVector<char, 0> Buffer;

  void anchor() override {};

public:
  LogicalRecord(GOFFOStream &OS) : raw_svector_ostream(Buffer), OS(OS) {}
  ~LogicalRecord() override { OS << str(); }

  LogicalRecord &operator<<(yaml::BinaryRef B) {
    B.writeAsBinary(*this);
    return *this;
  }
};

class GOFFState {
  void writeHeader(const GOFFYAML::ModuleHeader &ModHdr);
  void writeRelocationDirectory(const GOFFYAML::RelocationDirectory &RelDir);
  void writeSymbol(const GOFFYAML::Symbol &Sym);
  void writeText(const GOFFYAML::Text &Txt);
  void writeDeferredLength(const GOFFYAML::DeferredLength &Len);
  void writeEnd(const GOFFYAML::EndOfModule &EndMod);

  void reportError(const Twine &Msg) {
    ErrHandler(Msg);
    HasError = true;
  }

  GOFFState(raw_ostream &OS, GOFFYAML::Object &Doc,
            yaml::ErrorHandler ErrHandler)
      : GW(OS), Doc(Doc), ErrHandler(ErrHandler), HasError(false) {}

  bool writeObject();

public:
  static bool writeGOFF(raw_ostream &OS, GOFFYAML::Object &Doc,
                        yaml::ErrorHandler ErrHandler);

private:
  GOFFOStream GW;
  GOFFYAML::Object &Doc;
  yaml::ErrorHandler ErrHandler;
  bool HasError;
};

void GOFFState::writeHeader(const GOFFYAML::ModuleHeader &ModHdr) {
  // See
  // https://www.ibm.com/docs/en/zos/3.1.0?topic=formats-module-header-record.
  GW.newRecord(GOFF::RT_HDR);
  LogicalRecord LR(GW);
  LR << zeros(45)                          // Reserved.
     << binaryBe(ModHdr.ArchitectureLevel) // The architecture level.
     << binaryBe(ModHdr.PropertiesLength)  // Length of module properties.
     << zeros(6);                          // Reserved.
  if (ModHdr.Properties)
    LR << *ModHdr.Properties; // Module properties.
}

void GOFFState::writeRelocationDirectory(
    const GOFFYAML::RelocationDirectory &RelDir) {
  // See
  // https://www.ibm.com/docs/en/zos/3.1.0?topic=formats-relocation-directory-record.
  GW.newRecord(GOFF::RT_RLD);
  LogicalRecord LR(GW);
  LR << zeros(1)                 // Reserved.
     << binaryBe(RelDir.Length); // Length of the data items.
  for (auto &Rel : RelDir.Relocs) {
    // TODO Conditional Sequential Resolution Flag.
    LR << binaryBe(uint8_t(Rel.Flags));
    LR << binaryBe(uint8_t(Rel.ReferentType) << 4 | uint8_t(Rel.ReferenceType));
    LR << binaryBe(uint8_t(Rel.Action) << 1 | uint8_t(0 /* Fetch/Store*/));
    LR << zeros(1); // Reserved.
    LR << binaryBe(Rel.TargetFieldByteLength);
    LR << binaryBe(uint8_t(Rel.BitLength) << 4 | uint8_t(Rel.BitOffset));
    LR << zeros(2); // Reserved.
    if (Rel.RPointer.has_value())
      LR << binaryBe(*Rel.RPointer);
    if (Rel.PPointer.has_value())
      LR << binaryBe(*Rel.PPointer);
    if (Rel.Offset.has_value())
      LR << binaryBe(*Rel.Offset);
    LR << zeros(8); // Reserved.
  }
}

void GOFFState::writeSymbol(const GOFFYAML::Symbol &Sym) {
  // See
  // https://www.ibm.com/docs/en/zos/3.1.0?topic=formats-external-symbol-definition-record
  SmallString<80> SymName;
  if (std::error_code EC = ConverterEBCDIC::convertToEBCDIC(Sym.Name, SymName))
    reportError("conversion error on " + Sym.Name);
  size_t SymLength = SymName.size();
  if (SymLength > GOFF::MaxDataLength)
    reportError("symbol name is too long: " + Twine(SymLength));

  GW.newRecord(GOFF::RT_ESD);
  LogicalRecord LR(GW);
  LR //<< binaryBe(Sym.Type)          // Symbol type
     << binaryBe(Sym.ID)            // ESDID
     << binaryBe(Sym.OwnerID)       // Owner ESDID
     << binaryBe(uint32_t(0))       // Reserved
     << binaryBe(Sym.Address)       // Offset/Address
     << binaryBe(uint32_t(0))       // Reserved
     << binaryBe(Sym.Length)        // Length
     << binaryBe(Sym.ExtAttrID)     // Extended attributes
     << binaryBe(Sym.ExtAttrOffset) // Extended attributes data offset
     << binaryBe(uint32_t(0))       // Reserved
     //<< binaryBe(Sym.NameSpace)     // Namespace ID
     //<< binaryBe(Sym.Flags)         // Flags
     << binaryBe(Sym.FillByteValue) // Fill byte value
     << binaryBe(uint8_t(0))        // Reserved
     << binaryBe(Sym.PSectID)       // PSECT ID
     << binaryBe(Sym.Priority);     // Priority
#if 0
// TODO Fix!
  if (Sym.Signature)
    LR << *Sym.Signature; // Signature
  else
    LR << zeros(8);
#define BIT(E, N) (Sym.BAFlags & GOFF::E ? 1 << (7 - N) : 0)
  LR << binaryBe(Sym.Amode) // Behavioral attributes - Amode
     << binaryBe(Sym.Rmode) // Behavioral attributes - Rmode
     << binaryBe(uint8_t(Sym.TextStyle << 4 | Sym.BindingAlgorithm))
     << binaryBe(uint8_t(Sym.TaskingBehavior << 5 | BIT(ESD_BA_Movable, 3) |
                         BIT(ESD_BA_ReadOnly, 4) | Sym.Executable))
     << binaryBe(uint8_t(BIT(ESD_BA_NoPrime, 1) | Sym.BindingStrength))
     << binaryBe(uint8_t(Sym.LoadingBehavior << 6 | BIT(ESD_BA_COMMON, 2) |
                         BIT(ESD_BA_Indirect, 3) | Sym.BindingScope))
     << binaryBe(uint8_t(Sym.LinkageType << 5 | Sym.Alignment))
     << zeros(3) // Behavioral attributes - Reserved
     << binaryBe(static_cast<uint16_t>(SymLength)) // Name length
     << SymName.str();
#undef BIT
#endif
}

void GOFFState::writeText(const GOFFYAML::Text &Txt) {
  // See https://www.ibm.com/docs/en/zos/3.1.0?topic=grf-text-record.
  GW.newRecord(GOFF::RT_TXT);
  LogicalRecord LR(GW);
  LR << binaryBe(uint8_t(Txt.Style)) // Text record style.
     << binaryBe(
            Txt.ESDID) // ESDID of the element/part to which this data belongs.
     << zeros(4)       // Reserved.
     << binaryBe(Txt.Offset)      // Starting offset from element/part.
     << binaryBe(Txt.TrueLength)  // True length if encoded.
     << binaryBe(Txt.Encoding)    // Encoding.
     << binaryBe(Txt.DataLength); // Total length of data.
  if (Txt.Data)
    LR << *Txt.Data; // Data.
  else
    LR << zeros(Txt.DataLength);
}

void GOFFState::writeDeferredLength(const GOFFYAML::DeferredLength &Len) {
  // See
  // https://www.ibm.com/docs/en/zos/3.1.0?topic=formats-deferred-element-length-record.
  GW.newRecord(GOFF::RT_LEN);
  LogicalRecord LR(GW);
  LR << zeros(3)              // Reserved.
     << binaryBe(Len.Length); // Length of the data items.
  for (const llvm::GOFFYAML::ElementLength &ElemLen : Len.Data) {
    LR << binaryBe(ElemLen.ESDID)   // ESDID.
       << zeros(4)                  // Reserved.
       << binaryBe(ElemLen.Length); // Length of element ESDID.
  }
}

void GOFFState::writeEnd(const GOFFYAML::EndOfModule &EndMod) {
  // See https://www.ibm.com/docs/en/zos/3.1.0?topic=formats-end-module-record.
  SmallString<16> EntryName;
  if (std::error_code EC =
          ConverterEBCDIC::convertToEBCDIC(EndMod.EntryName, EntryName))
    reportError("conversion to EBCDIC 1047 failed on " + EndMod.EntryName);

  GW.newRecord(GOFF::RT_END);
  LogicalRecord LR(GW);
  LR << binaryBe(uint8_t(EndMod.Flags)) // The flags.
     << binaryBe(uint8_t(EndMod.AMODE)) // The addressing mode.
     << zeros(3)                        // Reserved.
     << binaryBe(EndMod.RecordCount)    // The record count.
     << binaryBe(EndMod.ESDID)          // ESDID of the entry point.
     << zeros(4)                        // Reserved.
     << binaryBe(EndMod.Offset)         // Offset of entry point.
     << binaryBe(EndMod.NameLength)     // Length of external name.
     << EntryName;                      // Name of the entry point.
}

bool GOFFState::writeObject() {
  for (const std::unique_ptr<GOFFYAML::RecordBase> &RecPtr : Doc.Records) {
    const GOFFYAML::RecordBase *Rec = RecPtr.get();
    switch (Rec->getKind()) {
    case GOFFYAML::RecordBase::Kind::ModuleHeader:
      writeHeader(*static_cast<const GOFFYAML::ModuleHeader *>(Rec));
      break;
    case GOFFYAML::RecordBase::Kind::RelocationDirectory:
      writeRelocationDirectory(
          *static_cast<const GOFFYAML::RelocationDirectory *>(Rec));
      break;
    case GOFFYAML::RecordBase::Kind::Symbol:
      writeSymbol(*static_cast<const GOFFYAML::Symbol *>(Rec));
      break;
    case GOFFYAML::RecordBase::Kind::Text:
      writeText(*static_cast<const GOFFYAML::Text *>(Rec));
      break;
    case GOFFYAML::RecordBase::Kind::DeferredLength:
      writeDeferredLength(*static_cast<const GOFFYAML::DeferredLength *>(Rec));
      break;
    case GOFFYAML::RecordBase::Kind::EndOfModule:
      writeEnd(*static_cast<const GOFFYAML::EndOfModule *>(Rec));
      break;
    }
    if (HasError)
      return false;
  }
  return true;
}

bool GOFFState::writeGOFF(raw_ostream &OS, GOFFYAML::Object &Doc,
                          yaml::ErrorHandler ErrHandler) {
  GOFFState State(OS, Doc, ErrHandler);
  return State.writeObject();
}
} // namespace

namespace llvm {
namespace yaml {

bool yaml2goff(llvm::GOFFYAML::Object &Doc, raw_ostream &Out,
               ErrorHandler ErrHandler) {
  return GOFFState::writeGOFF(Out, Doc, ErrHandler);
}

} // namespace yaml
} // namespace llvm
