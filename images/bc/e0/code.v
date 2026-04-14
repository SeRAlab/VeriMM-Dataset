module top_module(
	input clk,
	input reset_n,
	input enable,
	output reg [5:0] count);always @(posedge clk or negedge reset_n) begin
		if (!reset_n)
			count <= 6'b0;
		else if (enable)
			count <= count + 1;
	end

endmodule