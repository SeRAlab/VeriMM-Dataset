module top_module (
	input clk,
	input x,
	input y,
	output reg z,
	output reg state);reg q;
	always @(posedge clk)
		q <= x | (q & y);

	assign z = q;
	assign state = q;
			
endmodule