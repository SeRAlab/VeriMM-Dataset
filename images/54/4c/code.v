module top_module(input clk,input rst,output [3:0] channel,input new_sample,input [9:0] sample,input [3:0] sample_channel,output [9:0] out);assign channel = 4'd0; 
 reg [9:0] sample_d, sample_q; 
 assign out = sample_q; 
 always @(*) begin 
  sample_d = sample_q; 
  if (new_sample && sample_channel == 4'd0) 
  sample_d = sample; 
 end 
 always @(posedge clk) begin 
  if (rst) begin 
  sample_q <= 10'd0; 
  end else begin 
  sample_q <= sample_d; 
  end 
 end 
 endmodule