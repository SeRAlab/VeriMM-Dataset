module top_module(in, clk, out);input [31:0] in;
input clk;
output [31:0] out;

	assign out = in << 2;

endmodule