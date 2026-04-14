module enable_sequential_module_with_enable (
	input clock,
	input enable, 
	output reg c,
	output reg d);always @(negedge clock)
	if (enable)
		c <= 1;
	else
		c <= 0;
		
always @(posedge clock)
	if (enable)
		d <= 1;
	else
		d <= 0;
endmodule