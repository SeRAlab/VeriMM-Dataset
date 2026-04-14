module top_module( A, B, O );input [15:0] A;
  input [15:0] B;
  output [31:0] O;

  wire S_15_15,S_16_14;

  assign S_15_15 = (A[15] & B[15]);
  assign S_16_14 = S_15_15;
  assign O = {1'b0,S_16_14,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0};

endmodule