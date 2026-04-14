module sequential_module (
	input clock,
	input rst,
	input d1,
	input d2,
	output reg q);always @(posedge clock or posedge rst)
	if (rst)
		q <= 0;
	else
		q <= d1 & d2;
endmodule