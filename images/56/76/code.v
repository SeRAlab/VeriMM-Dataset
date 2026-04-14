module top_module(
	input clk,
	input reset,
	output reg [17:0] q);wire feedback = q[17] ^ q[16] ^ q[15] ^ q[12];
	always @(posedge clk) begin
		if (reset)
			q <= 18'h1;
		else
			q <= {q[16:0], feedback};
	end
endmodule