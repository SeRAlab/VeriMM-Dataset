module top_module(input clk_in,input test_mode,input clock_en,output clk_out);`ifdef FPGA_SOURCE 
  assign clk_out = clk_in; 
 `endif 
 `ifndef FPGA_SOURCE 
 reg enb; 
 always@(*) 
  if (!clk_in) 
  enb = (clock_en | test_mode); 
 assign clk_out = enb & clk_in; 
 `endif 
 endmodule