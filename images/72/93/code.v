module top_module(IN1, IN2, SEL, OUT);input IN1;
  input IN2;
  input SEL;
  output OUT;

  wire NOT_SEL;
  assign NOT_SEL = ~SEL;

  wire AND1;
  assign AND1 = IN1 & NOT_SEL;

  wire AND2;
  assign AND2 = IN2 & SEL;

  assign OUT = AND1 | AND2;

endmodule