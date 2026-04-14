module top_module(input clk,input en,input rst,input [31:0] limit,input [31:0] count,output reg clk_0,output reg done);reg [31:0] ndCount; 
  initial clk_0 = 1'b0; 
  initial ndCount = 32'h00000000; 
  always@(negedge clk) begin 
  if(en) begin 
  if(count > ndCount) begin 
  ndCount <= count + limit; 
  clk_0 <= ~clk_0; 
  end 
  else begin 
  ndCount <= ndCount; 
  clk_0 <= clk_0; 
  end 
  end 
  else begin 
  ndCount <= count+limit; 
  clk_0 <= 1'b0; 
  end 
  end 
 endmodule