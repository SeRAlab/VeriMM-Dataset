module top_module (
	input clock,
	input h, 
	output reg m,
	output reg n);always @(negedge clock)
		m <= h;
		
	always @(posedge clock)
		n <= h;
endmodule