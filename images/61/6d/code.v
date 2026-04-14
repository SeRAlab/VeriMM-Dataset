module bitwise_operation (
	input [21:0] input_vec,
	output [20:0] output_and,
	output [21:1] output_or,
	output [21:0] output_xor);assign output_and = input_vec & input_vec[21:1];
assign output_or = input_vec | input_vec[21:1];
assign output_xor = input_vec^{input_vec[0], input_vec[21:1]};

endmodule