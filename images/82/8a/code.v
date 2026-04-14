module sequential_reset_module_with_rst (
	input clock,
	input rst, 
	output reg h,
	output reg k);always @(negedge clock or posedge rst)
	if (rst)
		h <= 0;
	else
		h <= rst;
		
always @(posedge clock or posedge rst)
	if (rst)
		k <= 0;
	else
		k <= rst;
endmodule