module top_module (
	input clk,
	input p,
	input q,
	output reg r,
	output reg state);reg s;
	always @(posedge clk)
		s <= p & q;

	assign r = s;
	assign state = s;
			
endmodule