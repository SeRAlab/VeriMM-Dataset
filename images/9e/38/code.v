module further_module (
	input clock,
	input m,
	output reg n,
	output reg o);always @(negedge clock)
	n <= m;

always @(posedge clock)
	o <= m;
endmodule