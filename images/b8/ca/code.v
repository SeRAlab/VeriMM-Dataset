module sequential_module (
	input clock,
	input rst,
	input enable, 
	output reg q);always @(posedge clock or posedge rst)
	if (rst)
		q <= 0;
	else if (enable)
		q <= 1;
	else
		q <= 0;
endmodule