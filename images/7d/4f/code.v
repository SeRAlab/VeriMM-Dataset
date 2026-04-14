module top_module(
	input [31:0] inval,
	output [31:0] endian_twiddled_data);assign endian_twiddled_data = { inval[7:0], inval[15:8], inval[23:16], inval[31:24] };
endmodule