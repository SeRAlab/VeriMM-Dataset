module top_module(
	input clk,
	input reset,
	output reg [3:0] q);wire feedback = q[3] ^ q[2] ^ q[1];
	always @(posedge clk) begin
		if (reset)
			q <= 4'h1;
		else
			q <= {q[2:0], feedback};
	end
endmodule