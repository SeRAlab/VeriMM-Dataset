module sequential_module (
	input clock,
	input rst,
	input x,
	output reg y);always @(posedge clock or posedge rst)
	if (rst)
		y <= 0;
	else
		y <= x;
endmodule