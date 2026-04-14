module top_module(clock);parameter InitDelay = 10, Ton = 50, Toff = 50; 
  output clock; 
  reg clock; 
  initial begin 
  #InitDelay clock = 1; 
  end 
  always begin 
  #Ton clock = ~clock; 
  #Toff clock = ~clock; 
  end 
 endmodule