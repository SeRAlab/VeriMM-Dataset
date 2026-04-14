module top_module(
	input clk,
	input reset,
	output reg [21:0] q);wire feedback = q[21] ^ q[20] ^ q[16] ^ q[2];
	always @(posedge clk) begin
		if (reset)
			q <= 22'h1;
		else
			q <= {q[20:0], feedback};
	end
endmodule