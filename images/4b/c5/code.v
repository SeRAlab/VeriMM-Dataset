module top_module(
	input clk,
	input load,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk)
		if (load)
			q <= data;
		else
			q <= {q[6:0], 1'b0};

endmodule