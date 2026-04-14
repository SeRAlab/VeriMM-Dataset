module some_other_module (
	input clock,
	input s, 
	output reg e,
	output reg f);always @(negedge clock)
		e <= s;
		
	always @(posedge clock)
		f <= s;
endmodule