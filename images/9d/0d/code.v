module top_module(CLK, EN, TE, ENCLK);input CLK, EN, TE;
  output ENCLK;
  
  // Using a simple conditional assignment for clock gating
  assign ENCLK = (EN & ~TE) ? CLK : 1'b0;

endmodule