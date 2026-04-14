module top_module(
	input clk,
	input reset,
	output reg [15:0] q);always @(posedge clk)
		if (reset)
			q <= 16'b0000000000000001;
		else
			q <= {q[14:0], q[15] ^ q[13] ^ q[12] ^ q[10]};

endmodule