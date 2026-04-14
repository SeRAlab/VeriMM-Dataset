module top_module(u, reset, clk, w );input u; 
  input reset; 
  input clk; 
  output reg w; 
  always @ (posedge clk or posedge reset) begin 
  if (reset == 1'b1) begin 
  w <= 1'b0; 
  end 
  else begin 
  w <= u; 
  end 
  end 
 endmodule