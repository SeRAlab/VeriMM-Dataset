module bit_compare (
	input [11:0] vect,
	output [10:0] and_out,
	output [11:1] or_out,
	output [11:0] xor_out);assign and_out = vect & vect[11:1];
assign or_out = vect | vect[11:1];
assign xor_out = vect^{vect[0], vect[11:1]};

endmodule