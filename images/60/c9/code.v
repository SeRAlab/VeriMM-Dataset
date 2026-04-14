module top_module(
	input clk,
	input reset,
	input load,
	input [7:0] data,
	output reg [7:0] q);always @(posedge clk) begin
		if (reset)
			q <= 8'b00000000;
		else if (load)
			q <= data;
		else
			q <= {1'b0, q[7:1]};
	end
endmodule