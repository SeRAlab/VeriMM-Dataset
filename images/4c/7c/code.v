module top_module(
	input clk,
	input enable,
	input reset,
	input up_down,
	output reg [3:0] q);always @(posedge clk) begin
	if (reset)
		q <= 4'b0000;
	else if (enable)
		q <= up_down ? q + 1 : q - 1;
end
endmodule