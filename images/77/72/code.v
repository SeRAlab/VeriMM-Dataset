module top_module(
	input clk,
	input reset,
	input set,
	output reg [5:0] q);always @(posedge clk) begin
		if (reset)
			q <= 6'b0;
		else if (set)
			q <= 6'b111111;
	end
endmodule