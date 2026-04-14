module top_module(
  input [3:0] A,
  input [3:0] B,
  output [3:0] out
);assign out = A ^ B; // Bitwise XOR operation
endmodule