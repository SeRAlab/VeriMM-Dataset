module top_module (
	input clock,
	input s, 
	output reg m,
	output reg n);always @(negedge clock)
		m <= s;
		
	always @(posedge clock)
		n <= s;
endmodule