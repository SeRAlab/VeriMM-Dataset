module top_module(input clk,input rst,output reg np_tag_gnt,input np_tag_inc,output [7:0] tag_value,input [31:0] completion_pending);reg rst_reg; 
 reg [4:0] tag_value_i; 
 always@(posedge clk) rst_reg <= rst; 
 always@(posedge clk)begin 
  if(completion_pending[tag_value_i[4:0]]) 
  np_tag_gnt <= 1'b0; 
  else 
  np_tag_gnt <= 1'b1; 
 end 
 assign tag_value[7:0] = {3'b000,tag_value_i[4:0]}; 
  always@(posedge clk)begin 
  if(rst_reg)begin 
  tag_value_i[4:0] <= 5'b00000; 
  end else if(np_tag_inc)begin 
  tag_value_i <= tag_value_i + 1; 
  end 
  end 
 endmodule