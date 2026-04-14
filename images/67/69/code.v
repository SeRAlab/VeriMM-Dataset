module bitwise_compare (
	input [23:0] value,
	output [22:0] out_and,
	output [23:1] out_or,
	output [23:0] out_xor);assign out_and = value & value[23:1];
assign out_or = value | value[23:1];
assign out_xor = value^{value[0], value[23:1]};

endmodule