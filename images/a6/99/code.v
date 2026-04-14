module top_module(x, y, z, o);input [31:0] x, y, z;
	output [31:0] o;

	wire [31:0] temp;

	assign temp = y ^ z;
	assign o = z ^ (x & temp);

endmodule