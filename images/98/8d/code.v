module top_module(
  input [3:0] DIN,
  input [1:0] SEL,
  output DOUT
);assign DOUT = (DIN[0] & ~SEL[0] & ~SEL[1]) | (DIN[1] & SEL[0] & ~SEL[1]) | (DIN[2] & ~SEL[0] & SEL[1]) | (DIN[3] & SEL[0] & SEL[1]);
endmodule