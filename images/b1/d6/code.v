module top_module (
	input clock,
	input e, 
	output reg u,
	output reg v);always @(negedge clock)
		u <= e;
		
	always @(posedge clock)
		v <= e;
endmodule