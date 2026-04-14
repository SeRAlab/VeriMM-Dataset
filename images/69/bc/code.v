module final_module (
	input clock,
	input p,
	output reg q,
	output reg r);always @(negedge clock)
	q <= p;

always @(posedge clock)
	r <= p;
endmodule