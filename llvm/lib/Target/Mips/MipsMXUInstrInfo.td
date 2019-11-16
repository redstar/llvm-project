//===- MipsMXUInstrInfo.td - MXU ASE instructions -*- tablegen ------------*-=//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file describes Ingenic MXU ASE instructions.
//
//===----------------------------------------------------------------------===//

def Simm12Lsl2AsmOperand
    : SimmLslAsmOperandClass<12, [], 2>;

def simm12_lsl2 : Operand<i32> {
  let EncoderMethod = "getSimm12Lsl2Encoding";
  let DecoderMethod = "DecodeSimm12Lsl2";
  let ParserMatchClass = Simm12Lsl2AsmOperand;
}

def EptnAsmOperand : AsmOperandClass {
  let Name = "EPTN";
  let ParserMethod = "parseEptn";
  let PredicateMethod = "isImm";
  let RenderMethod = "addImmOperands";
}

def eptn : Operand<i32> {
//  let EncoderMethod = "getSizeInsEncoding";
//  let DecoderMethod = "DecodeInsSize";
  let ParserMatchClass = EptnAsmOperand;
}

def OptnAsmOperand : AsmOperandClass {
  let Name = "OPTN";
  let ParserMethod = "parseOptn";
  let PredicateMethod = "isImm";
  let RenderMethod = "addImmOperands";
}

def optn : Operand<i32> {
//  let EncoderMethod = "getSizeInsEncoding";
//  let DecoderMethod = "DecodeInsSize";
  let ParserMatchClass = OptnAsmOperand;
}

class MXU_FOUR_ADR_DESC<string instr_asm, SDPatternOperator OpNode,
                        RegisterOperand ROXR,
                        InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd))];
  InstrItinClass Itinerary = itin;
}

class MXU_FOUR_ADR_EPTN_OPTN_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXR,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, eptn:$pat1, optn:$pat2);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd, $pat1, $pat2");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, eptn:$pat1, optn:$pat2))];
  InstrItinClass Itinerary = itin;
}

class MXU_FOUR_ADR_EPTN_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXR,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, eptn:$pat1);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd, $pat1");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, eptn:$pat1))];
  InstrItinClass Itinerary = itin;
}

class MXU_FOUR_ADR_OPTN_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXR,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, optn:$pat2);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd, $pat2");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, optn:$pat2))];
  InstrItinClass Itinerary = itin;
}

class MXU_FOUR_ADR_OPTN2_DESC<string instr_asm, SDPatternOperator OpNode,
                              RegisterOperand ROXR,
                              InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, optn:$pat1);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd, $pat1");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, optn:$pat1))];
  InstrItinClass Itinerary = itin;
}

class MXU_FOUR_ADR_SFT_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXR,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, uimm4:$sft);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc, $xrd, $sft");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc, ROXR:$xrd, uimm4:$sft))];
  InstrItinClass Itinerary = itin;
}

class MXU_THREE_ADR_DESC<string instr_asm, SDPatternOperator OpNode,
                         RegisterOperand ROXR,
                         InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROXR:$xrc);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $xrc");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROXR:$xrc))];
  InstrItinClass Itinerary = itin;
}

class MXU_TWO_ADR_GPR_DESC<string instr_asm, SDPatternOperator OpNode,
                         RegisterOperand ROXR, RegisterOperand ROS,
                         InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXR:$xra);
  dag InOperandList = (ins ROXR:$xrb, ROS:$rb);
  string AsmString = !strconcat(instr_asm, "\t$xra, $xrb, $rb");
  list<dag> Pattern = [(set ROXR:$xra, (OpNode ROXR:$xrb, ROS:$rb))];
  InstrItinClass Itinerary = itin;
}

class MXU_S32_MOVE_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXRD, RegisterOperand ROS,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXRD:$xra);
  dag InOperandList = (ins ROS:$rt);
  string AsmString = !strconcat(instr_asm, "\t$xra, $rt");
  list<dag> Pattern = [(set ROXRD:$xra, (OpNode ROS:$rt))];
  InstrItinClass Itinerary = itin;
}

class MXU_S32_LOADSTORE_DESC<string instr_asm, SDPatternOperator OpNode,
                             RegisterOperand ROXRD, RegisterOperand ROS,
							 ValueType Ty,
                             InstrItinClass itin = NoItinerary> {
  dag OutOperandList = (outs ROXRD:$xrd);
  dag InOperandList = (ins ROS:$rs, simm12_lsl2:$ofs);
  string AsmString = !strconcat(instr_asm, "\t$xrd, $rs, $ofs");
  list<dag> Pattern = [(set ROXRD:$xrd, (OpNode ROS:$rs, simm12_lsl2:$ofs))];
  InstrItinClass Itinerary = itin;
//  string DecoderMethod = "DecodeMSA128Mem";
}

def MUX_D16MUL : MXU_FOUR_ADR_PAT1_FMT<0b001000, 0b00>,
                 MXU_FOUR_ADR_OPTN_DESC<"d16mul", null_frag, MXUDOpnd>;
def MUX_D16MULF : MXU_FOUR_ADR_PAT1_FMT<0b001001, 0b00>,
                  MXU_FOUR_ADR_OPTN_DESC<"d16mulf", null_frag, MXUDOpnd>;
def MUX_D16MULE : MXU_FOUR_ADR_PAT1_FMT<0b001001, 0b01>,
                  MXU_FOUR_ADR_OPTN_DESC<"d16mule", null_frag, MXUDOpnd>;
def MUX_D16MAC : MXU_FOUR_ADR_BASE_FMT<0b001010>,
                 MXU_FOUR_ADR_EPTN_OPTN_DESC<"d16mac", null_frag, MXUDOpnd>;
def MUX_D16MACF : MXU_FOUR_ADR_BASE_FMT<0b001011>,
                  MXU_FOUR_ADR_EPTN_OPTN_DESC<"d16macf", null_frag, MXUDOpnd>;
def MUX_D16MADL : MXU_FOUR_ADR_BASE_FMT<0b001100>,
                  MXU_FOUR_ADR_EPTN_OPTN_DESC<"d16madl", null_frag, MXUDOpnd>;
// S16MAD
def MUX_Q16ADD : MXU_FOUR_ADR_BASE_FMT<0b001110>,
                 MXU_FOUR_ADR_EPTN_OPTN_DESC<"q16add", null_frag, MXUQOpnd>;
def MUX_D16MACE : MXU_FOUR_ADR_BASE_FMT<0b001111>,
                  MXU_FOUR_ADR_EPTN_OPTN_DESC<"d16mace", null_frag, MXUDOpnd>;
def MUX_Q8MUL : MXU_FOUR_ADR_FMT<0b111000, 0b00, 0b00>,
                MXU_FOUR_ADR_DESC<"q8mul", null_frag, MXUQOpnd>;
def MUX_Q8MULSU : MXU_FOUR_ADR_FMT<0b111000, 0b00, 0b10>,
                  MXU_FOUR_ADR_DESC<"q8mulsu", null_frag, MXUQOpnd>;
def MUX_Q8MOVZ : MXU_THREE_ADR_MINOR_FMT<0b000, 0b111001>,
                 MXU_THREE_ADR_DESC<"q8movz", null_frag, MXUQOpnd>;
def MUX_Q8MOVN : MXU_THREE_ADR_MINOR_FMT<0b001, 0b111001>,
                 MXU_THREE_ADR_DESC<"q8movn", null_frag, MXUQOpnd>;
def MUX_D16MOVZ : MXU_THREE_ADR_MINOR_FMT<0b010, 0b111001>,
                  MXU_THREE_ADR_DESC<"d16movz", null_frag, MXUDOpnd>;
def MUX_D16MOVN : MXU_THREE_ADR_MINOR_FMT<0b011, 0b111001>,
                  MXU_THREE_ADR_DESC<"d16movn", null_frag, MXUDOpnd>;
def MUX_S32MOVZ : MXU_THREE_ADR_MINOR_FMT<0b100, 0b111001>,
                  MXU_THREE_ADR_DESC<"s32movz", null_frag, MXUSOpnd>;
def MUX_S32MOVN : MXU_THREE_ADR_MINOR_FMT<0b101, 0b111001>,
                  MXU_THREE_ADR_DESC<"s32movn", null_frag, MXUSOpnd>;
def MUX_Q8MAC : MXU_FOUR_ADR_PAT2_FMT<0b111010, 0b00>,
                MXU_FOUR_ADR_EPTN_DESC<"q8mac", null_frag, MXUDOpnd>;
def MUX_Q8MACSU : MXU_FOUR_ADR_PAT2_FMT<0b111010, 0b10>,
                  MXU_FOUR_ADR_EPTN_DESC<"q8macsu", null_frag, MXUDOpnd>;
def MUX_Q16SCOP : MXU_FOUR_ADR_FMT<0b111011, 0b00, 0b00>,
                  MXU_FOUR_ADR_DESC<"q16scop", null_frag, MXUQOpnd>;
def MUX_Q8MADL : MXU_FOUR_ADR_PAT2_FMT<0b111100, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"q8madl", null_frag, MXUDOpnd>;
def MUX_S32SFL : MXU_FOUR_ADR_PAT2_FMT<0b111101, 0b00>,
                 MXU_FOUR_ADR_OPTN2_DESC<"s32sfl", null_frag, MXUDOpnd>;
def MUX_Q8SAD : MXU_FOUR_ADR_FMT<0b111110, 0b00, 0b00>,
                MXU_FOUR_ADR_DESC<"q8sad", null_frag, MXUQOpnd>;
def MUX_D32ADD : MXU_FOUR_ADR_PAT2_FMT<0b011000, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"d32add", null_frag, MXUDOpnd>;
def MUX_D32ACC : MXU_FOUR_ADR_PAT2_FMT<0b011001, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"d32acc", null_frag, MXUDOpnd>;
def MUX_D32ACCM : MXU_FOUR_ADR_PAT2_FMT<0b011001, 0b01>,
                  MXU_FOUR_ADR_EPTN_DESC<"d32accm", null_frag, MXUDOpnd>;
def MUX_D32ASUM : MXU_FOUR_ADR_PAT2_FMT<0b011001, 0b10>,
                  MXU_FOUR_ADR_EPTN_DESC<"d32asum", null_frag, MXUDOpnd>;
def MUX_Q16ACC : MXU_FOUR_ADR_PAT2_FMT<0b011011, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"q16acc", null_frag, MXUDOpnd>;
def MUX_Q16ACCM : MXU_FOUR_ADR_PAT2_FMT<0b011011, 0b01>,
                  MXU_FOUR_ADR_EPTN_DESC<"q16accm", null_frag, MXUDOpnd>;
def MUX_D16ASUM : MXU_FOUR_ADR_PAT2_FMT<0b011011, 0b10>,
                  MXU_FOUR_ADR_EPTN_DESC<"d16asum", null_frag, MXUDOpnd>;
def MUX_Q8ADDE : MXU_FOUR_ADR_PAT2_FMT<0b011100, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"q8adde", null_frag, MXUDOpnd>;
// D8SUM, D8SUMC
def MUX_Q8ACCE : MXU_FOUR_ADR_PAT2_FMT<0b011101, 0b00>,
                 MXU_FOUR_ADR_EPTN_DESC<"q8acce", null_frag, MXUDOpnd>;
def MUX_S32CPS : MXU_THREE_ADR_MINOR_FMT<0b000, 0b000111>,
                 MXU_THREE_ADR_DESC<"s32cps", null_frag, MXUSOpnd>;
def MUX_D16CPS : MXU_THREE_ADR_MINOR_FMT<0b010, 0b000111>,
                 MXU_THREE_ADR_DESC<"d16cps", null_frag, MXUDOpnd>;
def MUX_Q8ABD : MXU_THREE_ADR_MINOR_FMT<0b100, 0b000111>,
                MXU_THREE_ADR_DESC<"q8abd", null_frag, MXUQOpnd>;
def MUX_Q16SAT : MXU_THREE_ADR_MINOR_FMT<0b110, 0b000111>,
                 MXU_THREE_ADR_DESC<"q16sat", null_frag, MXUQOpnd>;
def MUX_S32SLT : MXU_THREE_ADR_MINOR_FMT<0b000, 0b000110>,
                 MXU_THREE_ADR_DESC<"s32slt", setlt, MXUSOpnd>;
def MUX_D16SLT : MXU_THREE_ADR_MINOR_FMT<0b001, 0b000110>,
                 MXU_THREE_ADR_DESC<"d16slt", setlt, MXUDOpnd>;
def MUX_D16AVG : MXU_THREE_ADR_MINOR_FMT<0b010, 0b000110>,
                 MXU_THREE_ADR_DESC<"d16avg", null_frag, MXUDOpnd>;
def MUX_D16AVGR : MXU_THREE_ADR_MINOR_FMT<0b011, 0b000110>,
                  MXU_THREE_ADR_DESC<"d16avgr", null_frag, MXUDOpnd>;
def MUX_Q8AVG : MXU_THREE_ADR_MINOR_FMT<0b100, 0b000110>,
                MXU_THREE_ADR_DESC<"q8avg", null_frag, MXUQOpnd>;
def MUX_Q8AVGR : MXU_THREE_ADR_MINOR_FMT<0b101, 0b000110>,
                 MXU_THREE_ADR_DESC<"q8avgr", null_frag, MXUQOpnd>;
// Q8ADD
def MUX_S32MAX : MXU_THREE_ADR_MINOR_FMT<0b000, 0b000011>,
                 MXU_THREE_ADR_DESC<"s32max", smax, MXUSOpnd>;
def MUX_S32MIN : MXU_THREE_ADR_MINOR_FMT<0b001, 0b000011>,
                 MXU_THREE_ADR_DESC<"s32min", smin, MXUSOpnd>;
def MUX_D16MAX : MXU_THREE_ADR_MINOR_FMT<0b010, 0b000011>,
                 MXU_THREE_ADR_DESC<"d16max", smax, MXUDOpnd>;
def MUX_D16MIN : MXU_THREE_ADR_MINOR_FMT<0b011, 0b000011>,
                 MXU_THREE_ADR_DESC<"d16min", smin, MXUDOpnd>;
def MUX_Q8MAX : MXU_THREE_ADR_MINOR_FMT<0b100, 0b000011>,
                MXU_THREE_ADR_DESC<"q8max", smax, MXUQOpnd>;
def MUX_Q8MIN : MXU_THREE_ADR_MINOR_FMT<0b101, 0b000011>,
                MXU_THREE_ADR_DESC<"q8min", smin, MXUQOpnd>;
def MUX_Q8SLT : MXU_THREE_ADR_MINOR_FMT<0b110, 0b000011>,
                MXU_THREE_ADR_DESC<"q8slt", setlt, MXUQOpnd>;
def MUX_Q8SLTU : MXU_THREE_ADR_MINOR_FMT<0b111, 0b000011>,
                 MXU_THREE_ADR_DESC<"q8sltu", setult, MXUQOpnd>;
// D32SLL etc.
def MUX_D32SLL : MXU_FOUR_ADR_SFT_FMT<0b110000>,
                 MXU_THREE_ADR_DESC<"d32sll", null_frag, MXUQOpnd>;
def MUX_D32SLR : MXU_FOUR_ADR_SFT_FMT<0b110001>,
                 MXU_THREE_ADR_DESC<"d32slr", null_frag, MXUQOpnd>;
// D32SALR
def MUX_D32SAR : MXU_FOUR_ADR_SFT_FMT<0b110011>,
                 MXU_THREE_ADR_DESC<"d32sar", null_frag, MXUQOpnd>;
def MUX_Q16SLL : MXU_FOUR_ADR_SFT_FMT<0b110100>,
                 MXU_THREE_ADR_DESC<"q16sll", null_frag, MXUQOpnd>;
def MUX_Q16SLR : MXU_FOUR_ADR_SFT_FMT<0b110101>,
                 MXU_THREE_ADR_DESC<"q16slr", null_frag, MXUQOpnd>;
def MUX_Q16SAR : MXU_FOUR_ADR_SFT_FMT<0b110111>,
                 MXU_THREE_ADR_DESC<"q16sar", null_frag, MXUQOpnd>;
def MUX_D32SLLV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b000>,
                  MXU_TWO_ADR_GPR_DESC<"d32sllv", null_frag, MXUQOpnd, GPR32Opnd>;
def MUX_D32SLRV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b001>,
                  MXU_TWO_ADR_GPR_DESC<"d32slrv", null_frag, MXUQOpnd, GPR32Opnd>;
def MUX_D32SARV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b011>,
                  MXU_TWO_ADR_GPR_DESC<"d32sarv", null_frag, MXUQOpnd, GPR32Opnd>;
def MUX_Q16SLLV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b100>,
                  MXU_TWO_ADR_GPR_DESC<"q16sllv", null_frag, MXUQOpnd, GPR32Opnd>;
def MUX_Q16SLRV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b101>,
                  MXU_TWO_ADR_GPR_DESC<"q16slrv", null_frag, MXUQOpnd, GPR32Opnd>;
def MUX_Q16SARV : MXU_TWO_ADR_GPR_MINOR_FMT<0b110110, 0b111>,
                  MXU_TWO_ADR_GPR_DESC<"q16sarv", null_frag, MXUQOpnd, GPR32Opnd>;


def MUX_S32NOR : MXU_THREE_ADR_MINOR_FMT<0b100, 0b100111>,
                 MXU_THREE_ADR_DESC<"s32nor", MipsVNOR, MXUSOpnd>;
def MUX_S32AND : MXU_THREE_ADR_MINOR_FMT<0b101, 0b100111>,
                 MXU_THREE_ADR_DESC<"s32and", and, MXUSOpnd>;
def MUX_S32OR : MXU_THREE_ADR_MINOR_FMT<0b110, 0b100111>,
                MXU_THREE_ADR_DESC<"s32or", or, MXUSOpnd>;
def MUX_S32XOR : MXU_THREE_ADR_MINOR_FMT<0b111, 0b100111>,
                 MXU_THREE_ADR_DESC<"s32xor", xor, MXUSOpnd>;

def MUX_S32M2I : MXU_S32_MOVE_FMT<0b101110>,
                 MXU_S32_MOVE_DESC<"s32m2i", load, MXUSPlusCROpnd, GPR32Opnd>;
def MUX_S32I2M : MXU_S32_MOVE_FMT<0b101111>,
                 MXU_S32_MOVE_DESC<"s32i2m", load, MXUSPlusCROpnd, GPR32Opnd>;

def MUX_S32LDD : MXU_S32_LOADSTORE_FMT<0b0, 0b010000>,
                 MXU_S32_LOADSTORE_DESC<"s32ldd", null_frag, MXUSOpnd, GPR32Opnd, i32>;
def MUX_S32LDDR : MXU_S32_LOADSTORE_FMT<0b1, 0b010000>,
                  MXU_S32_LOADSTORE_DESC<"s32lddr", null_frag, MXUSOpnd, GPR32Opnd, i32>;
