module top_module(
  input [3:0] A, B,
  input Cin,
  output [3:0] Sum,
  output Cout
);wire [3:0] c;
  wire [3:0] s;

  // Simple half adder implementation
  // Assumption: The half adder has inputs A and B, and outputs SUM and COUT
  assign s[0] = A[0] ^ B[0]; // Sum for first bit
  assign c[0] = A[0] & B[0]; // Carry for first bit

  assign s[1] = A[1] ^ B[1] ^ c[0]; // Sum for second bit
  assign c[1] = (A[1] & B[1]) | (c[0] & (A[1] ^ B[1])); // Carry for second bit

  assign s[2] = A[2] ^ B[2] ^ c[1]; // Sum for third bit
  assign c[2] = (A[2] & B[2]) | (c[1] & (A[2] ^ B[2])); // Carry for third bit

  assign s[3] = A[3] ^ B[3] ^ c[2]; // Sum for fourth bit
  assign Cout = (A[3] & B[3]) | (c[2] & (A[3] ^ B[3])); // Final carry out

  assign Sum = s;

endmodule