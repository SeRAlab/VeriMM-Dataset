module top_module(input pll_asleep,input pllrefclk,output plloutclk,input pll_RESET,input [1:0] pll_OD,input [7:0] pll_M,input [4:0] pll_N);wire pllout; 
  `ifdef FPGA_SOURCE 
  assign pllout = pllrefclk; 
  `else 
  assign pllout = pllrefclk; 
  `endif 
  assign plloutclk = pllout; 
 endmodule