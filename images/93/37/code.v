module bit_relationship (
	input [15:0] data,
	output [14:0] result_and,
	output [15:1] result_or,
	output [15:0] result_xor);assign result_and = data & data[15:1];
assign result_or = data | data[15:1];
assign result_xor = data^{data[0], data[15:1]};

endmodule