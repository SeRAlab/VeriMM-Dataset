module top_module (
	input clk,
	input e,
	input f,
	output reg g,
	output reg state);reg q;
	always @(posedge clk)
		q <= e & f;

	assign g = q;
	assign state = q;
			
endmodule