module top_module(
  input wire in1,
  input wire in2,
  input wire Cin,
  output wire S,
  output wire Cout
  );wire XOR1;
  wire XOR2;
  wire AND1;
  wire AND3;
  wire OR4;

  assign XOR1 = in1 ^ in2;
  assign XOR2 = XOR1 ^ Cin;
  assign AND3 = XOR1 & Cin;
  assign AND1 = in1 & in2;
  assign OR4  = AND3 | AND1;

  assign S = XOR2;
  assign Cout = OR4;


endmodule