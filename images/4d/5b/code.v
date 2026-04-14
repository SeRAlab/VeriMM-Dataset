module top_module( clk, data_in, reset, data_out);output data_out; 
  input clk; 
  input data_in; 
  input reset; 
  reg data_in_d1 ; 
  reg data_out ; 
  always @(posedge clk or posedge reset) 
  begin 
  if (reset == 1) data_in_d1 <= 1; 
  else data_in_d1 <= data_in; 
  end 
  always @(posedge clk or posedge reset) 
  begin 
  if (reset == 1) data_out <= 1; 
  else data_out <= data_in_d1; 
  end 
 endmodule