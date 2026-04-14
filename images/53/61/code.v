module top_module(
	input clk,
	input enable,
	input reset,
	output reg [11:0] q);always @(posedge clk) begin
	if (reset)
		q <= 12'b000000000000;
	else if (enable)
		q <= q + 2;
end
endmodule