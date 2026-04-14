module enable_reset_sequential_module_with_en (
	input clock,
	input en, 
	output reg f,
	output reg g);always @(negedge clock)
	if (en)
		f <= 1;
	else
		f <= 0;
		
always @(posedge clock)
	if (en)
		g <= 1;
	else
		g <= 0;
endmodule