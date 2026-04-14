module top_module(input clk, input sel, input in0, input in1, output reg out);initial out=0; 
  always@(posedge clk) begin 
  out<=sel?in1:in0; 
  end 
 endmodule