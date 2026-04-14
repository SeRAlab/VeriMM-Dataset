module top_module(clk,D,clear,Load,Q);input wire clk,Load,clear;	
input wire [31:0] D;
output reg [31:0] Q;
always @(posedge clk or posedge clear)
	if(clear)	Q<=0;
	else if (Load)	Q<=D;endmodule