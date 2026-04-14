module top_module(
  input CLK, EN, TE,
  output ENCLK
);assign ENCLK = (EN & TE & CLK);

endmodule