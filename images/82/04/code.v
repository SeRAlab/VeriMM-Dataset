module magnitude_comparator(
	input wire [3:0] a,
	input wire [3:0] b,
	output wire a_gt_b,
	output wire a_eq_b,
	output wire a_lt_b
);assign a_gt_b = (a > b);
	assign a_eq_b = (a == b);
	assign a_lt_b = (a < b);
endmodule