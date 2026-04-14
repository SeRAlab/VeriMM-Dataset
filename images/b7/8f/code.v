module comparator4bit(
	input [3:0] a,
	input [3:0] b,
	output lt,
	output gt,
	output eq);assign lt = (a < b);
assign gt = (a > b);
assign eq = (a == b);

endmodule