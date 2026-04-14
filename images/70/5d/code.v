module top_module(
	input clk,
	input enable,
	input reset,
	output reg [4:0] q);always @(posedge clk) begin
	if (reset)
		q <= 5'b00000;
	else if (enable)
		q <= q + 3;
end
endmodule