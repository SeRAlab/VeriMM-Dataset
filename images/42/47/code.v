module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] Sum,
  output Cout
);wire [3:0] Xor_out, And_out;
  wire Cin_and_Xor_out;

  // Implement XOR logic
  assign Xor_out = A ^ B;

  // Implement AND logic
  assign And_out = A & B;

  // Implement Cin AND (A XOR B) logic
  assign Cin_and_Xor_out = Cin & Xor_out;

  // Implement Sum output
  assign Sum = Xor_out ^ Cin;

  // Implement Cout output
  assign Cout = Cin_and_Xor_out | And_out;

endmodule