module top_module(clk,data_in,reset_n,data_out);output data_out; 
  input clk; 
  input data_in; 
  input reset_n; 
  reg data_in_d1 ; 
  reg data_out ; 
  always @(posedge clk or negedge reset_n) 
  begin 
  if (reset_n == 0) 
  data_in_d1 <= 0; 
  else if (1) 
  data_in_d1 <= data_in; 
  end 
  always @(posedge clk or negedge reset_n) 
  begin 
  if (reset_n == 0) 
  data_out <= 0; 
  else if (1) 
  data_out <= data_in_d1; 
  end 
 endmodule