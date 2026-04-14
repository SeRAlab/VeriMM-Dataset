module top_module(
	input clk,
	input reset,
	input load,
	input [31:0] data,
	output reg [31:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 32'hDEADBEEF;
		else if (load)
			q <= data;
	end
endmodule