//===- MipsMXUInstrFormats.td - Mips Instruction Formats ---*- tablegen -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

class MXUInst : MipsInst<(outs), (ins), "", [], NoItinerary, FrmOther>,
                ASE_MXU {
  let EncodingPredicates = [HasStdEnc];
  let Inst{31-26} = 0b011100;
}

class MXU_FOUR_ADR_BASE_FMT<bits<6> ext>: MXUInst {
  bits<4> xrd;
  bits<4> xrc;
  bits<4> xrb;
  bits<4> xra;
  bits<2> pat1;
  bits<2> pat2;

  let Inst{25-24} = pat1;
  let Inst{23-22} = pat2;
  let Inst{21-18} = xrd;
  let Inst{17-14} = xrc;
  let Inst{13-10} = xrb;
  let Inst{9-6} = xra;
  let Inst{5-0} = ext;
}

class MXU_FOUR_ADR_FMT<bits<6> ext, bits<2> pt1, bits<2> pt2>: MXU_FOUR_ADR_BASE_FMT<ext> {
  let pat1 = pt1;
  let pat2 = pt2;
}

class MXU_FOUR_ADR_PAT1_FMT<bits<6> ext, bits<2> pat>: MXU_FOUR_ADR_BASE_FMT<ext> {
  let pat1 = pat;
}

class MXU_FOUR_ADR_PAT2_FMT<bits<6> ext, bits<2> pat>: MXU_FOUR_ADR_BASE_FMT<ext> {
  let pat2 = pat;
}

class MXU_FOUR_ADR_SFT_FMT<bits<6> ext>: MXU_FOUR_ADR_BASE_FMT<ext> {
  bits<4> sft;

  let pat1 = sft{0-1};
  let pat2 = sft{2-3};
}

class MXU_THREE_ADR_MINOR_FMT<bits<3> minor, bits<6> ext>: MXUInst {
  bits<4> xrc;
  bits<4> xrb;
  bits<4> xra;

  let Inst{25-21} = 0b00000;
  let Inst{20-18} = minor;
  let Inst{17-14} = xrc;
  let Inst{13-10} = xrb;
  let Inst{9-6} = xra;
  let Inst{5-0} = ext;
}

class MXU_TWO_ADR_GPR_MINOR_FMT<bits<6> ext, bits<3> minor>: MXUInst {
  bits<5> rb;
  bits<4> xrb;
  bits<4> xra;

  let Inst{25-21} = rb;
  let Inst{20-18} = minor;
  let Inst{17-14} = xrb;
  let Inst{13-10} = xra;
  let Inst{9-6} = 0b0000;
  let Inst{5-0} = ext;
}

class MXU_S32_MOVE_FMT<bits<6> ext>: MXUInst {
  bits<5> rt;
  bits<5> xra;

  let Inst{25-21} = 0b00000;
  let Inst{20-16} = rt;
  let Inst{15-11} = 0b00000;
  let Inst{10-6} = xra;
  let Inst{5-0} = ext;
}

class MXU_S32_LOADSTORE_FMT<bits<1> rev, bits<6> ext>: MXUInst {
  bits<5> rs;
  bits<10> ofs;
  bits<4> xrd;

  let Inst{25-21} = rs;
  let Inst{20} = rev;
  let Inst{19-10} = ofs;
  let Inst{9-6} = xrd;
  let Inst{5-0} = ext;
}
