module top_module(input [15:0] in, output [31:0] out);assign out[15:0] = in;
	assign out[31:16] = 16'b0000_0000_0000_0000;endmodule