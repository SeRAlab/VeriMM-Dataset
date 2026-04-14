module top_module(input clk_i,input hold_i,input rst_i,input wire [4:0] in,output reg [4:0] out);initial begin 
  out <= 5'h0; 
  end 
  always @(posedge clk_i) begin 
  if (rst_i) 
  out <= #1 5'h0; 
  else if (hold_i) 
  out <= #1 out; 
  else 
  out <= #1 in; 
  end 
 endmodule