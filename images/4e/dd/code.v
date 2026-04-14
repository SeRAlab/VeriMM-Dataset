module gt_comparator(
	input wire [7:0] a,
	input wire [7:0] b,
	output wire gt
);
assign gt = (a > b);
endmodule