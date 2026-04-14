module top_module(
	input clk,
	input reset,
	input enable,
	output reg [6:0] count);always @(posedge clk) begin
		if (reset)
			count <= 7'b0000000;
		else if (enable)
			count <= count + 2;
	end

endmodule