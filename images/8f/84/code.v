module reset_enable_sequential_module (
	input clock,
	input reset, 
	output reg u,
	output reg v);always @(negedge clock or posedge reset)
	if (reset)
		u <= 0;
	else
		u <= reset;
		
always @(posedge clock or posedge reset)
	if (reset)
		v <= 0;
	else
		v <= reset;
endmodule