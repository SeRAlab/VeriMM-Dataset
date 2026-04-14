module top_module(
  input [2:0] A,
  input [2:0] B,
  output a_greater,
  output b_greater,
  output equal
);assign a_greater = (A > B) ? 1'b1 : 1'b0;
  assign b_greater = (B > A) ? 1'b1 : 1'b0;
  assign equal = (A == B) ? 1'b1 : 1'b0;

endmodule