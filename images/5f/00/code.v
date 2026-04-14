module top_module(input clk_i,input hold_i,input rst_i,input wire in,output reg out);initial begin 
  out <= 1'h0; 
  end 
  always @(posedge clk_i) begin 
  if (rst_i) 
  out <= #1 1'b0; 
  else if (hold_i) 
  out <= #1 out; 
  else 
  out <= #1 in; 
  end 
 endmodule