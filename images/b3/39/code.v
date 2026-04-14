module top_module(
  input [7:0] A,
  input [7:0] B,
  input Cin,
  output Cout,
  output [7:0] C
);wire [7:0] S;
  wire [7:0] C1;
  wire [7:0] C2;

  // Full adder logic
  assign S = A ^ B ^ Cin;
  assign C1 = A & B;
  assign C2 = Cin & (A ^ B);
  assign Cout = C1 | C2;

  assign C = S;

endmodule