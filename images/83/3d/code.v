module top_module(clk);output reg clk = 0;
  always
    #10 clk = ~clk;endmodule