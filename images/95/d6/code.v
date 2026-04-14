module lfsr(
	input clk,
	input reset,
	output reg [2:0] q);always @(posedge clk)
	if (reset)
		q <= 3'b001;
	else
		q <= {q[1:0], q[2] ^ q[1]};

endmodule