module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output [n-1:0] and_res,
  output [n-1:0] or_res,
  output [n-1:0] xor_res,
  output [n-1:0] not_res
);parameter n = 4; // number of bits in A and B

assign and_res = A & B;
assign or_res = A | B;
assign xor_res = A ^ B;
assign not_res = ~A;

endmodule