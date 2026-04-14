module top_module(A, B, O);input [7:0] A, B;
  output [8:0] O;
  assign O[2] = B[4];
  assign O[0] = 1'b0;
  assign O[3] = 1'b0;
  assign O[1] = B[3];
  assign O[4] = O[0];
  assign O[5] = B[5];
  assign O[6] = A[6];
  assign O[7] = A[6];
  assign O[8] = A[7];
endmodule