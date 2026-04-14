module top_module(

  clk_in_p,
  clk_in_n,
  clk);parameter   BUFTYPE       = 0;
  localparam  SERIES7       = 0;
  localparam  VIRTEX6       = 1;

  input     clk_in_p;
  input     clk_in_n;
  output    clk;
  
  assign clk = clk_in_p;

endmodule