module revised_module (
	input clock,
	input j,
	output reg k,
	output reg l);always @(negedge clock)
	k <= j;

always @(posedge clock)
	l <= j;
endmodule