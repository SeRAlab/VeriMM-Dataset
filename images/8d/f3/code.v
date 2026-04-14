module bitwise_relation (
	input [9:0] in_vector,
	output [8:0] res_left,
	output [9:1] res_right,
	output [9:0] res_xor);assign res_left = in_vector & in_vector[9:1];
assign res_right = in_vector | in_vector[9:1];
assign res_xor = in_vector^{in_vector[0], in_vector[9:1]};

endmodule