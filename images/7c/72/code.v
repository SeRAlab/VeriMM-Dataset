module sequential_module (
	input clock,
	input rst, 
	output reg x);always @(negedge clock or posedge rst)
	if (rst)
		x <= 0;
	else
		x <= rst;
endmodule