module top_module(
	input clk,
	input reset,
	input enable,
	output reg [15:0] count);always @(posedge clk) begin
		if (reset)
			count <= 16'hFFFF;
		else if (enable)
			count <= count - 2;
	end

endmodule