module top_module( 
  IN0, 
  IN1,
  SEL, 
  F 
);input IN0, IN1, SEL;
  output F;

  assign F  = (~SEL&IN0)|(SEL&IN1);

endmodule