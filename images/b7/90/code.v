module bitwise_check (
	input [3:0] vec,
	output [2:0] result_left,
	output [3:1] result_right,
	output [3:0] result_xor);assign result_left = vec & vec[3:1];
assign result_right = vec | vec[3:1];
assign result_xor = vec^{vec[0], vec[3:1]};

endmodule