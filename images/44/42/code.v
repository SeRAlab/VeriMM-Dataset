module top_module(clockSignal);parameter start = 0, halfPeriod = 50; 
  output clockSignal; 
  reg clockSignal; 
  initial 
  clockSignal = start; 
  always 
  #halfPeriod clockSignal = ~clockSignal; 
 endmodule