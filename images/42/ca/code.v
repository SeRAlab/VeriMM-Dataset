module eq_comparator(
	input wire [7:0] a,
	input wire [7:0] b,
	output wire eq
);
assign eq = (a == b);
endmodule