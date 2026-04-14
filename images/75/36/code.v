module top_module(
	input clk,
	input reset,
	output reg [13:0] q);wire feedback = q[13] ^ q[12] ^ q[10] ^ q[0];
	always @(posedge clk) begin
		if (reset)
			q <= 14'h1;
		else
			q <= {q[12:0], feedback};
	end
endmodule