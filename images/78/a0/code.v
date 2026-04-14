module top_module(clk, xstart, xend, realy, q);parameter SCREENWIDTH = 0;
	parameter SCREENHEIGHT = 0;
	input clk, xstart, xend;
	input [9:0] realy;
	output q;

	assign q = xstart | xend | realy == 0 | realy == SCREENHEIGHT - 1;
endmodule