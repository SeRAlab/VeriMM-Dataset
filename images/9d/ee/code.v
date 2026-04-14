module prng(
	input clk,
	input reset,
	output reg [7:0] q);always @(posedge clk)
	if (reset)
		q <= 8'b00000001;
	else
		q <= {q[6:0], q[7] ^ q[5]};

endmodule