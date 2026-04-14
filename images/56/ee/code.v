module top_module(
	input clk,
	input reset,
	input increment,
	output reg [31:0] q);always @(posedge clk) begin
		if (reset)
			q <= 32'b0;
		else if (increment)
			q <= q + 1;
	end
endmodule