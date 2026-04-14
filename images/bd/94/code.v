module top_module(reg_out, clk, reset, flush, reg_in);parameter RegLen = 63; 
  output [RegLen:0] reg_out; 
  input clk; 
  input reset; 
  input flush; 
  input [RegLen:0] reg_in; 
  reg [RegLen:0] reg_val; 
  assign reg_out = reg_val; 
  always @(posedge clk) 
  begin 
  if (flush == 1'b1) 
  begin 
  reg_val <= 'b0; 
  end 
  else 
  begin 
  reg_val <= reg_in; 
  end 
  end 
  always @(posedge reset) 
  begin 
  reg_val = 'b0; 
  end 
 endmodule