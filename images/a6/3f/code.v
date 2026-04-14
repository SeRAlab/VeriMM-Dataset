module top_module(
  input A,
  input B,
  input C,
  input D,
  input [1:0] S,
  output Y
);wire notS0, notS1;

  assign notS0 = ~S[0];
  assign notS1 = ~S[1];

  assign Y = (A & notS1 & notS0) | (B & notS1 & S[0]) | (C & S[1] & notS0) | (D & S[1] & S[0]);

endmodule