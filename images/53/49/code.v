module top_module(
	input clk,
	input serial_in,
	output reg [3:0] q);always @(posedge clk)
	q <= {serial_in, q[3:1]};

endmodule