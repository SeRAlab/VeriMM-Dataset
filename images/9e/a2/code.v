module top_module(value, value_w);output [7:0] value, value_w; 
  reg [7:0] value; 
  parameter MY_VALUE = 12; 
  assign value_w = MY_VALUE + 1; 
  initial begin 
  #1; 
  value <= MY_VALUE; 
  end 
 endmodule