module yet_new_module (
	input clock,
	input x,
	output reg w,
	output reg y);always @(negedge clock)
	w <= x;

always @(posedge clock)
	y <= ~x;
endmodule