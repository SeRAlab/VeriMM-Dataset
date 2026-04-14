module top_module(out,clk, in, reset);input clk; 
  input in; 
  output out; 
  input reset; 
  reg out; 
  wire toggle; 
  assign toggle = in ? ~out : 
  out; 
  always @ (posedge clk or posedge reset) 
  if(reset) 
  out <= 1'b0; 
  else 
  out <= toggle; 
 endmodule