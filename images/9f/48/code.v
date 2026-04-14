module another_module (
	input clock,
	input n,
	output reg m,
	output reg p);always @(negedge clock)
	m <= n;

always @(posedge clock)
	p <= ~n;
endmodule