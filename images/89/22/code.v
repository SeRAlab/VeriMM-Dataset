module comparator(
	input [3:0] a, b,
	output eq);

	assign eq = (a == b);
	
endmodule