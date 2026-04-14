module binary_adder(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] Sum,
  output Cout
);

  wire [3:0] xor_out;
  wire [3:0] and_out;
  wire [3:0] or_out;

  // Calculate the XOR of A and B
  assign xor_out = A ^ B;

  // Calculate the AND of A and B
  assign and_out = A & B;

  // Calculate the OR of the AND and the shifted XOR
  assign or_out = {xor_out[3], or_out[2:0]} | and_out;

  // Calculate the sum
  assign Sum = xor_out ^ Cin;

  // Calculate the carry-out
  assign Cout = or_out[3];

endmodule