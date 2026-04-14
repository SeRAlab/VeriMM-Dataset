module top_module(
	input clk,
	input reset,
	output reg [11:0] q);wire feedback = q[11] ^ q[10] ^ q[9] ^ q[2];
	always @(posedge clk) begin
		if (reset)
			q <= 12'h1;
		else
			q <= {q[10:0], feedback};
	end
endmodule