module top_module(
  input [n-1:0] A,
  input [n-1:0] B,
  output [n-1:0] C
);parameter n = 4; // number of bits

// Bitwise AND
assign C = A & B;

// Bitwise OR
assign C = A | B;

// Bitwise XOR
assign C = A ^ B;

// Bitwise NOT
assign C = ~A;

endmodule