module top_module (
	input clock,
	input m, 
	output reg s,
	output reg t);always @(negedge clock)
		s <= m;
		
	always @(posedge clock)
		t <= m;
endmodule