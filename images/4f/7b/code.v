module top_module(input [25:0] in, output [31:0] out);assign out[25:0] = in;
	assign out[31:26] = 6'b00_0000;endmodule