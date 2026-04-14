module top_module(clockSignal, reg_mem_clk);parameter start = 0, halfPeriod = 50; 
  output clockSignal; 
  output reg_mem_clk; 
  reg clockSignal; 
  reg reg_mem_clk; 
  initial begin 
  clockSignal = start; 
  reg_mem_clk = start; 
  end 
  always begin 
  #halfPeriod clockSignal = ~clockSignal; 
  #3 reg_mem_clk = clockSignal; 
  end 
 endmodule