module top_module(output reg clock,output reg reset);always begin 
  #50 clock = ~clock; 
  end 
  initial 
  begin 
  clock = 0; 
  reset = 1; 
  #20 reset = 0; 
  end 
 endmodule