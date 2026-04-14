module top_module(
  A,
  B,
  C,
  D,
  EN,
  Y
);input [1:0] A;
  input [1:0] B;
  input [1:0] C;
  input [1:0] D;
  input EN;
  output Y;

  assign Y = (EN == 1'b1) && (A == 2'b11) && (B == 2'b10) && (C == 2'b01) && (D == 2'b00);

endmodule