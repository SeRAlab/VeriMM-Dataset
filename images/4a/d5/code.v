module lfsr(
	input clk,
	input reset,
	output reg [11:0] q);always @(posedge clk)
	if (reset)
		q <= 12'b000000000001;
	else
		q <= {q[10:0], q[11] ^ q[10]};

endmodule