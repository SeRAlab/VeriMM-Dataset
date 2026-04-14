module top_module(input [4:0] ID_rs,input [4:0] ID_rt,input EX_regwe,input [4:0] EX_RW,input MEM_ramtoreg,input [4:0] MEM_RW,input ID_jmp_need_reg,input ID_jmp_reg,input ID_misprediction,output branch_flushD,output branch_flushE);assign branch_flushD = ID_jmp_reg || ID_misprediction; 
  assign branch_flushE = (ID_jmp_need_reg && EX_regwe && EX_RW != 0 && (EX_RW == ID_rs || EX_RW == ID_rt)) 
  || (ID_jmp_need_reg && MEM_ramtoreg && MEM_RW != 0 && (MEM_RW == ID_rs || MEM_RW == ID_rt)); 
 endmodule