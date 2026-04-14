module top_module(
  input [3:0] A,
  input [3:0] B,
  output [3:0] S,
  output C_out
);wire [3:0] carry;
  
  assign S = A + B;
  assign carry = (S[4] == 1) ? 1 : 0;
  assign C_out = carry;
  
endmodule