module top_module(input sys_clk,input [6:0] p1_a,output reg [31:0] p1_d,input [6:0] p2_a,output reg [31:0] p2_d,input p3_en,input [6:0] p3_a,input [31:0] p3_d);reg [31:0] mem1[0:127]; 
 always @(posedge sys_clk) begin 
  if(p3_en) 
  mem1[p3_a] <= p3_d; 
  p1_d <= mem1[p1_a]; 
 end 
 reg [31:0] mem2[0:127]; 
 always @(posedge sys_clk) begin 
  if(p3_en) 
  mem2[p3_a] <= p3_d; 
  p2_d <= mem2[p2_a]; 
 end 
 endmodule