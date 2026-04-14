module top_module(CLK, EN, TE, RESET, ENCLK);input CLK, EN, TE, RESET;
  output ENCLK;

  wire gated_clk;

  assign gated_clk = (EN & ~RESET) ? CLK : 1'b0;

  assign ENCLK = (TE) ? ~gated_clk : gated_clk;

endmodule