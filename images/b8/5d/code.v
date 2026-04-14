module new_another_module (
	input clock,
	input y,
	output reg x,
	output reg z);always @(negedge clock)
	x <= y;

always @(posedge clock)
	z <= ~y;
endmodule