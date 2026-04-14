module top_module(
  IN0,
  IN1,
  IN2,
  IN3,
  SEL,
  F
);input [3:0] IN0, IN1, IN2, IN3;
  input [1:0] SEL;
  output F;

  assign F = (SEL[1] & SEL[0]) ? IN3 :
             (SEL[1] & ~SEL[0]) ? IN2 :
             (~SEL[1] & SEL[0]) ? IN1 :
             (~SEL[1] & ~SEL[0]) ? IN0 :
             1'bx;

endmodule