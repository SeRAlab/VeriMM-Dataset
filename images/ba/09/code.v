module bitwise_comp (
	input [7:0] data_in,
	output [6:0] left_and,
	output [7:1] right_or,
	output [7:0] xor_wrap);assign left_and = data_in & data_in[7:1];
assign right_or = data_in | data_in[7:1];
assign xor_wrap = data_in^{data_in[0], data_in[7:1]};

endmodule