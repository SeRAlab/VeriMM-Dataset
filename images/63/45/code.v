module top_module(
	input clk,
	input enable,
	input reset,
	output reg [6:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 7'b0000000;
	else if (enable)
		q <= q + 4;
end
endmodule