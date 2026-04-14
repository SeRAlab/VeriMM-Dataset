module top_module (
	input clk,
	input p,
	input q,
	output reg r,
	output reg state);reg n;
	always @(posedge clk)
		n <= p&q | n&~p;

	assign r = n;
	assign state = n;
			
endmodule