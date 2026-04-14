module top_module( B, SEL_out );input [15:0] B;
  output [23:0] SEL_out;

  assign SEL_out[0] = 1'b0;
  assign SEL_out[23] = B[15];
  assign SEL_out[22] = B[14];
  assign SEL_out[20] = B[13];
  assign SEL_out[21] = B[13];
  assign SEL_out[19] = B[12];
  assign SEL_out[17] = B[11];
  assign SEL_out[18] = B[11];
  assign SEL_out[16] = B[10];
  assign SEL_out[14] = B[9];
  assign SEL_out[15] = B[9];
  assign SEL_out[13] = B[8];
  assign SEL_out[11] = B[7];
  assign SEL_out[12] = B[7];
  assign SEL_out[10] = B[6];
  assign SEL_out[8] = B[5];
  assign SEL_out[9] = B[5];
  assign SEL_out[7] = B[4];
  assign SEL_out[5] = B[3];
  assign SEL_out[6] = B[3];
  assign SEL_out[4] = B[2];
  assign SEL_out[2] = B[1];
  assign SEL_out[3] = B[1];
  assign SEL_out[1] = B[0];endmodule