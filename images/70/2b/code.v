module top_module(p0, p1, imm, aluSrc0, aluSrc1, src0, src1);input[15:0] p0, p1;
  input[7:0] imm;
  input aluSrc0, aluSrc1;
  output[15:0] src0, src1;
  
  assign src0 = aluSrc0 ? {{8{imm[7]}},imm} : p0;
  assign src1 = aluSrc1 ? {{12{imm[3]}},imm[3:0]} : p1;
  
endmodule