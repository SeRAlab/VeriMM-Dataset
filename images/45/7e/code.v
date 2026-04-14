module top_module(
  input CLK,
  input EN,
  input TE,
  output ENCLK
);assign ENCLK = (EN & TE) ? CLK : 1'b0;

endmodule