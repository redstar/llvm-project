//===-- GOFFYAML.cpp - GOFF YAMLIO implementation ---------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines classes for handling the YAML representation of GOFF.
//
//===----------------------------------------------------------------------===//

#include "llvm/ObjectYAML/GOFFYAML.h"
#include "llvm/BinaryFormat/GOFF.h"

namespace llvm {

namespace yaml {

void ScalarEnumerationTraits<GOFFYAML::GOFF_AMODE>::enumeration(
    IO &IO, GOFFYAML::GOFF_AMODE &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::ESD_##X)
  ECase(AMODE_None);
  ECase(AMODE_24);
  ECase(AMODE_31);
  ECase(AMODE_ANY);
  ECase(AMODE_64);
  ECase(AMODE_MIN);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarBitSetTraits<GOFFYAML::GOFF_RLDFLAGS>::bitset(
    IO &IO, GOFFYAML::GOFF_RLDFLAGS &Value) {
#define BCase(X) IO.bitSetCase(Value, #X, GOFF::RLD_##X)
  BCase(FLAG_SameRId);
  BCase(FLAG_SamePId);
  BCase(FLAG_SameOffset);
  BCase(FLAG_AmodeSensitive);
#undef BCase
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_RLDREFERENCETYPE>::enumeration(
    IO &IO, GOFFYAML::GOFF_RLDREFERENCETYPE &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::RLD_##X)
  ECase(RT_RAddress);
  ECase(RT_ROffset);
  ECase(RT_RLength);
  ECase(RT_RRelativeImmediate);
  ECase(RT_RTypeConstant);
  ECase(RT_RLongDisplacement);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_RLDREFERENTTYPE>::enumeration(
    IO &IO, GOFFYAML::GOFF_RLDREFERENTTYPE &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::RLD_##X)
  ECase(RO_Label);
  ECase(RO_Element);
  ECase(RO_Class);
  ECase(RO_Part);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_RLDACTION>::enumeration(
    IO &IO, GOFFYAML::GOFF_RLDACTION &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::RLD_##X)
  ECase(ACT_Add);
  ECase(ACT_Subtract);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_RLDFETCHSTORE>::enumeration(
    IO &IO, GOFFYAML::GOFF_RLDFETCHSTORE &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::RLD_##X)
  ECase(FS_Fetch);
  ECase(FS_Store);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_TXTRECORDSTYLE>::enumeration(
    IO &IO, GOFFYAML::GOFF_TXTRECORDSTYLE &Value) {
#define ECase(X) IO.enumCase(Value, #X, GOFF::TXT_##X)
  ECase(TS_Byte);
  ECase(TS_Structured);
  ECase(TS_Unstructured);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void ScalarEnumerationTraits<GOFFYAML::GOFF_ENDFLAGS>::enumeration(
    IO &IO, GOFFYAML::GOFF_ENDFLAGS &Value) {
#define ECase(X) IO.enumCase(Value, #X, unsigned(GOFF::END_##X) << 6)
  ECase(EPR_None);
  ECase(EPR_EsdidOffset);
  ECase(EPR_ExternalName);
  ECase(EPR_Reserved);
#undef ECase
  IO.enumFallback<Hex8>(Value);
}

void MappingTraits<GOFFYAML::ModuleHeader>::mapping(
    IO &IO, GOFFYAML::ModuleHeader &ModHdr) {
  IO.mapOptional("ArchitectureLevel", ModHdr.ArchitectureLevel, 0);
  IO.mapOptional("PropertiesLength", ModHdr.PropertiesLength, 0);
  IO.mapOptional("Properties", ModHdr.Properties);
}

void MappingTraits<GOFFYAML::Relocation>::mapping(IO &IO,
                                                  GOFFYAML::Relocation &Rel) {
  IO.mapRequired("Flags", Rel.Flags);
  IO.mapOptional("ReferenceType", Rel.ReferenceType, GOFF::RLD_RT_RAddress);
  IO.mapOptional("ReferentType", Rel.ReferentType, GOFF::RLD_RO_Label);
  IO.mapOptional("Action", Rel.Action, GOFF::RLD_ACT_Add);
  IO.mapOptional("FixupTarget", Rel.Action, GOFF::RLD_ACT_Add);
  IO.mapOptional("TargetFieldByteLength", Rel.TargetFieldByteLength, 0);
  IO.mapOptional("BitLength", Rel.BitLength, 0);
  IO.mapOptional("BitOffset", Rel.BitOffset, 0);
  IO.mapOptional("RPointer", Rel.RPointer);
  IO.mapOptional("PPointer", Rel.PPointer);
  IO.mapOptional("Offset", Rel.Offset);
}

void MappingTraits<GOFFYAML::RelocationDirectory>::mapping(
    IO &IO, GOFFYAML::RelocationDirectory &Rel) {
  IO.mapOptional("Length", Rel.Length, 0);
  IO.mapOptional("RelocationEntries", Rel.Relocs);
}

void MappingTraits<GOFFYAML::Symbol>::mapping(IO &IO, GOFFYAML::Symbol &Sym) {
  IO.mapRequired("Name", Sym.Name);
  //IO.mapRequired("Type", Sym.Type);
  IO.mapRequired("ID", Sym.ID);
  IO.mapOptional("OwnerID", Sym.OwnerID, 0);
  IO.mapOptional("Address", Sym.Address, 0);
  IO.mapOptional("Length", Sym.Length, 0);
  IO.mapOptional("ExtAttrID", Sym.ExtAttrID, 0);
  IO.mapOptional("ExtAttrOffset", Sym.ExtAttrOffset, 0);
  //IO.mapRequired("NameSpace", Sym.NameSpace);
  //IO.mapOptional("Flags", Sym.Flags, GOFFYAML::GOFF_ESDFlags(0));
  IO.mapOptional("FillByteValue", Sym.FillByteValue, 0);
  IO.mapOptional("PSectID", Sym.PSectID, 0);
  IO.mapOptional("Priority", Sym.Priority, 0);
  IO.mapOptional("Signature", Sym.Signature);
  IO.mapOptional("Amode", Sym.Amode, GOFF::ESD_AMODE_None);
  //IO.mapOptional("Rmode", Sym.Rmode, GOFF::ESD_RMODE_None);
  //IO.mapOptional("TextStyle", Sym.TextStyle, GOFF::ESD_TS_ByteOriented);
  //IO.mapOptional("BindingAlgorithm", Sym.BindingAlgorithm,
  //               GOFF::ESD_BA_Concatenate);
  //IO.mapOptional("TaskingBehavior", Sym.TaskingBehavior,
  //               GOFF::ESD_TA_Unspecified);
  //IO.mapOptional("Executable", Sym.Executable, GOFF::ESD_EXE_Unspecified);
  //IO.mapOptional("LinkageType", Sym.LinkageType, GOFF::ESD_LT_OS);
  //IO.mapOptional("BindingStrength", Sym.BindingStrength, GOFF::ESD_BST_Strong);
  //IO.mapOptional("LoadingBehavior", Sym.LoadingBehavior, GOFF::ESD_LB_Initial);
  //IO.mapOptional("BindingScope", Sym.BindingScope, GOFF::ESD_BSC_Unspecified);
  //IO.mapOptional("Alignment", Sym.Alignment, GOFF::ESD_ALIGN_Byte);
  //IO.mapOptional("BAFlags", Sym.BAFlags, 0);
}

void MappingTraits<GOFFYAML::Text>::mapping(IO &IO, GOFFYAML::Text &Txt) {
  IO.mapOptional("TextStyle", Txt.Style, GOFF::TXT_TS_Byte);
  IO.mapOptional("ESDID", Txt.ESDID, 0);
  IO.mapOptional("Offset", Txt.Offset, 0);
  IO.mapOptional("TrueLength", Txt.TrueLength, 0);
  IO.mapOptional("TextEncoding", Txt.Encoding, 0);
  IO.mapOptional("DataLength", Txt.DataLength, 0);
  IO.mapOptional("Data", Txt.Data);
}

void MappingTraits<GOFFYAML::ElementLength>::mapping(
    IO &IO, GOFFYAML::ElementLength &ElemLen) {
  IO.mapOptional("ESDID", ElemLen.ESDID, 0);
  IO.mapOptional("Length", ElemLen.Length, 0);
}

void MappingTraits<GOFFYAML::DeferredLength>::mapping(
    IO &IO, GOFFYAML::DeferredLength &Len) {
  IO.mapOptional("Length", Len.Length, 0);
  IO.mapOptional("Data", Len.Data);
}

void MappingTraits<GOFFYAML::EndOfModule>::mapping(IO &IO,
                                                   GOFFYAML::EndOfModule &End) {
  IO.mapOptional("Flags", End.Flags, 0);
  IO.mapOptional("AMODE", End.AMODE, 0);
  IO.mapOptional("RecordCount", End.RecordCount, 0);
  IO.mapOptional("ESDID", End.ESDID, 0);
  IO.mapOptional("Offset", End.Offset, 0);
  IO.mapOptional("NameLength", End.NameLength, 0);
  IO.mapOptional("EntryName", End.EntryName);
}

void CustomMappingTraits<GOFFYAML::RecordPtr>::inputOne(
    IO &IO, StringRef Key, GOFFYAML::RecordPtr &Elem) {
  if (Key == "ModuleHeader") {
    GOFFYAML::ModuleHeader ModHdr;
    IO.mapRequired("ModuleHeader", ModHdr);
    Elem = std::make_unique<GOFFYAML::ModuleHeader>(std::move(ModHdr));
  } else if (Key == "RelocationDirectory") {
    GOFFYAML::RelocationDirectory Txt;
    IO.mapRequired("RelocationDirectory", Txt);
    Elem = std::make_unique<GOFFYAML::RelocationDirectory>(std::move(Txt));
  } else if (Key == "Symbol") {
    GOFFYAML::Symbol Sym;
    IO.mapRequired("Symbol", Sym);
    Elem = std::make_unique<GOFFYAML::Symbol>(std::move(Sym));
  } else if (Key == "Text") {
    GOFFYAML::Text Txt;
    IO.mapRequired("Text", Txt);
    Elem = std::make_unique<GOFFYAML::Text>(std::move(Txt));
  } else if (Key == "DeferredLength") {
    GOFFYAML::DeferredLength Len;
    IO.mapRequired("DeferredLength", Len);
    Elem = std::make_unique<GOFFYAML::DeferredLength>(std::move(Len));
  } else if (Key == "End") {
    GOFFYAML::EndOfModule End;
    IO.mapRequired("End", End);
    Elem = std::make_unique<GOFFYAML::EndOfModule>(std::move(End));
  } else
    IO.setError(Twine("unknown record type name ").concat(Key));
}

void CustomMappingTraits<GOFFYAML::RecordPtr>::output(
    IO &IO, GOFFYAML::RecordPtr &Elem) {
  switch (Elem->getKind()) {
  case GOFFYAML::RecordBase::Kind::ModuleHeader:
    IO.mapRequired("ModuleHeader",
                   *static_cast<GOFFYAML::ModuleHeader *>(Elem.get()));
    break;
  case GOFFYAML::RecordBase::Kind::RelocationDirectory:
    IO.mapRequired("RelocationDirectory",
                   *static_cast<GOFFYAML::RelocationDirectory *>(Elem.get()));
    break;
  case GOFFYAML::RecordBase::Kind::Symbol:
    IO.mapRequired("Symbol", *static_cast<GOFFYAML::Symbol *>(Elem.get()));
    break;
  case GOFFYAML::RecordBase::Kind::Text:
    IO.mapRequired("Text", *static_cast<GOFFYAML::Text *>(Elem.get()));
    break;
  case GOFFYAML::RecordBase::Kind::DeferredLength:
    IO.mapRequired("DeferredLength",
                   *static_cast<GOFFYAML::DeferredLength *>(Elem.get()));
    break;
  case GOFFYAML::RecordBase::Kind::EndOfModule:
    IO.mapRequired("End", *static_cast<GOFFYAML::EndOfModule *>(Elem.get()));
    break;
  }
}

void MappingTraits<GOFFYAML::Object>::mapping(IO &IO, GOFFYAML::Object &Obj) {
  IO.mapTag("!GOFF", true);
  EmptyContext Context;
  yamlize(IO, Obj.Records, false, Context);
}

} // namespace yaml
} // namespace llvm
