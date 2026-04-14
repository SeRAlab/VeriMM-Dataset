module comparator_2bit(
	input wire [1:0] a,
	input wire [1:0] b,
	output wire equal
);assign equal = (a == b);
endmodule