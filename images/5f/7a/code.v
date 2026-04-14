module top_module(
	input clk,
	input load,
	input shift,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk) begin
		if (load)
			q <= data;
		else if (shift)
			q <= {1'b0, q[15:1]};
	end
endmodule