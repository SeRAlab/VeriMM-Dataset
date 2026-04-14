module top_module(comp2,
    out,
    RD_PNTR_WR);output comp2;
  input [11:0]out;
  input [11:0]RD_PNTR_WR;

  wire [5:0]v1_reg;
  
  // Calculate v1_reg
  assign v1_reg[0] = out[0] ^ RD_PNTR_WR[0];
  assign v1_reg[1] = out[2] ^ RD_PNTR_WR[2];
  assign v1_reg[2] = out[4] ^ RD_PNTR_WR[4];
  assign v1_reg[3] = out[6] ^ RD_PNTR_WR[6];
  assign v1_reg[4] = out[8] ^ RD_PNTR_WR[8];
  assign v1_reg[5] = out[10] ^ RD_PNTR_WR[10];
  
  // Calculate comp2
  assign comp2 = v1_reg[4] ^ v1_reg[3];
endmodule