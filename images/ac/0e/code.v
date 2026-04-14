module top_module(
	input clk,
	input rst,
	input [31:0] count_limit,
	output reg [31:0] count_value
);always @(posedge clk or posedge rst) begin
		if (rst) begin
			count_value <= 0;
		end else if (count_value >= count_limit) begin
			count_value <= 0;
		end else begin
			count_value <= count_value + 1;
		end
	end

endmodule