module top_module(in, clk, out);input [7:0]in;				
	input clk;					
	output [7:0]out;			
	reg [7:0]out;
	always@(posedge clk)
		out = in;endmodule