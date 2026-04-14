module top_module(
	input clk,
	input parallel_load,
	input shift,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk) begin
		if (parallel_load)
			q <= data;
		else if (shift)
			q <= {1'b0, q[7:1]};
	end
endmodule