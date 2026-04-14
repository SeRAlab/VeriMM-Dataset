module new_module_7 (
	input clock,
	input p, 
	output reg q,
	output reg r);always @(negedge clock)
		q <= p;
		
	always @(posedge clock)
		r <= p;
endmodule