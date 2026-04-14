module top_module(
	input [31:0] input_d,
	input clk,
	input clr,
	input reset,
	output reg [31:0] output_q
	);always @(posedge clk)
		if (reset)
			output_q <= 0;
		else 
			output_q <= input_d;

	
endmodule