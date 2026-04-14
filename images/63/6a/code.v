module top_module(
  input [3:0] A,
  input [3:0] B,
  input Cin,
  output [3:0] S,
  output Cout
);wire [3:0] temp;
  wire carry;

  assign temp = A + B + Cin;
  assign Cout = temp[4];
  assign S = temp[3:0];

endmodule