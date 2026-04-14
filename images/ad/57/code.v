module top_module (
	input clk,
	input reset,
	input [15:0] d,
	output reg [15:0] q);always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 16'hFFFF;
		else
			q <= d;
	end
	
endmodule