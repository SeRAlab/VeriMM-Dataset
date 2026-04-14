module top_module(input wire clk,output wire [1:0] leds);wire ena = 1'b1; 
 reg [1:0] reg1; 
 always @(posedge clk) 
  reg1 <= 2'b11; 
 assign leds = (ena) ? reg1 : 2'bzz; 
 endmodule