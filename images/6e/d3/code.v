module yet_another_module (
	input clock,
	input v,
	output reg u,
	output reg w);always @(negedge clock)
	u <= ~v;

always @(posedge clock)
	w <= v;
endmodule