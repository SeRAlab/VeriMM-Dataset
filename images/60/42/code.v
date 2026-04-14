module reset_sequential_module (
	input clock,
	input reset, 
	output reg m,
	output reg n);always @(negedge clock or posedge reset)
	if (reset)
		m <= 0;
	else
		m <= reset;
		
always @(posedge clock or posedge reset)
	if (reset)
		n <= 0;
	else
		n <= reset;
endmodule