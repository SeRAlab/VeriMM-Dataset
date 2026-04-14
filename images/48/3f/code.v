module neighbor_relation (
	input [19:0] bits,
	output [18:0] res_and,
	output [19:1] res_or,
	output [19:0] res_xor);assign res_and = bits & bits[19:1];
assign res_or = bits | bits[19:1];
assign res_xor = bits^{bits[0], bits[19:1]};

endmodule