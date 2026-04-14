module top_module(
  input A,
  input B,
  input SEL,
  output Y
);wire NOT_SEL;
  wire AND1;
  wire AND2;
  wire OR;

  assign NOT_SEL = ~SEL;
  assign AND1 = A & NOT_SEL;
  assign AND2 = B & SEL;
  assign OR = AND1 | AND2;

  assign Y = OR;

endmodule