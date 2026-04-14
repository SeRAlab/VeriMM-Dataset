module top_module(clock,data_in,reset_n,data_out);output data_out; 
  input clock; 
  input data_in; 
  input reset_n; 
  reg data_in_d1; 
  wire data_out; 
  always @(posedge clock or negedge reset_n) 
  begin 
  if (reset_n == 0) 
  data_in_d1 <= 0; 
  else 
  data_in_d1 <= data_in; 
  end 
  assign data_out = data_in ^ data_in_d1; 
 endmodule