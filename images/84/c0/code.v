module relation_check (
	input [5:0] input_bits,
	output [4:0] and_left,
	output [5:1] or_right,
	output [5:0] xor_cycle);assign and_left = input_bits & input_bits[5:1];
assign or_right = input_bits | input_bits[5:1];
assign xor_cycle = input_bits^{input_bits[0], input_bits[5:1]};

endmodule