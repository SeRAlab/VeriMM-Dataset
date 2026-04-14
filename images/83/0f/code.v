module top_module(result,clk, enable, reset);input clk; 
  input enable; 
  input reset; 
  output result; 
  reg result; 
  always @ (posedge clk) begin 
  if (reset) begin 
  result <= 1'd0; 
  end else begin 
  result <= enable; 
  end 
  end 
 endmodule