module top_module (
	input clk,
	input [7:0] a,
	input reset,
	output reg [7:0] b);always @(posedge clk) begin
		if (reset)
			b <= 8'b0;
		else
			b <= a << 1;
	end
	
endmodule