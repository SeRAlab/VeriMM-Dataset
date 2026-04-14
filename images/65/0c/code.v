module top_module(
	input clk,
	input enable,
	input reset,
	input [11:0] reset_value,
	output reg [11:0] q);always @(posedge clk) begin
	if (reset)
		q <= reset_value;
	else if (enable)
		q <= q + 1;
end
endmodule