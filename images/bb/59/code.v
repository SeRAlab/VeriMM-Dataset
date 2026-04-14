module top_module(clk, in, out, rst);input clk; 
	input rst; 
	input [31:0] in; 
	output [31:0] out; 
	reg signed [31:0] out;

	always @(posedge clk)
		out = rst ? 32'b00000000000000000000000000000000 : in ; 
endmodule