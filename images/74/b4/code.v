module top_module(
	input clk,
	input reset,
	input serial_in,
	output reg [3:0] q);always @(posedge clk or posedge reset)
		if (reset)
			q <= 0;
		else
			q <= {serial_in, q[3:1]};
	
endmodule