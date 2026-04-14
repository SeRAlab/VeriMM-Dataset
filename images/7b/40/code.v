module top_module(clk);output reg clk; 
 initial 
  begin 
  clk = 0; 
  end 
  always 
  begin 
  #250 clk = 1; 
  #250 clk = 0; 
  end 
 endmodule