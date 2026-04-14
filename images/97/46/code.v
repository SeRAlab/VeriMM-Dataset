module top_module(clk, in, out);parameter N = 1;

	input clk;
	input [N-1:0] in;
	output [N-1:0] out;

	reg [N-1:0] buffer = 0;

	assign out = in & ~buffer;

	always @(posedge clk)
		buffer <= in;
endmodule