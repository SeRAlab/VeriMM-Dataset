module top_module (
	input clk,
	input [7:0] a,
	input [7:0] b,
	input reset,
	output reg [7:0] c);always @(posedge clk) begin
		if (reset)
			c <= 8'b0;
		else
			c <= a & b;
	end
	
endmodule