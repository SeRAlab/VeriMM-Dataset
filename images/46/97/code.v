module top_module(
	input clk,
	input reset,
	input load,
	input [31:0] data,
	output reg [31:0] q);always @(posedge clk) begin
		if (reset)
			q <= 32'hFFFFFFFF;
		else if (load)
			q <= data;
	end
endmodule