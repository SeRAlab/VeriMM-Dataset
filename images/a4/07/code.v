module top_module(
	input clk,
	input ena,
	input [15:0] data,
	output reg [15:0] q);always @(posedge clk) begin
		if (ena)
			q <= {q[15], q[15:1]};
	end
endmodule