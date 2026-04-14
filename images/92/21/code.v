module top_module(in, out);input [26-1:0] in;
	output [28-1:0] out;

	assign out = {in[25:0], 2'b00};endmodule