module my_other_module (
	input clock,
	input k,
	output reg j,
	output reg l);always @(negedge clock)
	j <= k;

always @(posedge clock)
	l <= ~k;
endmodule