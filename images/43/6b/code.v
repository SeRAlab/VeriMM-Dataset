module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output ENCLK;

  assign ENCLK = (TE == 1'b1) ? CLK : (EN == 1'b1) ? CLK : 1'b0;

endmodule