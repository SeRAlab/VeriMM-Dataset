module top_module(
	input clk,
	input load,
	input serial_in,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk)
		if (load)
			q <= data;
		else
			q <= {serial_in, q[7:1]};
	
endmodule