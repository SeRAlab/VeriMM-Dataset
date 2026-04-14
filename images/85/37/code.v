module top_module(
	input clk,
	input enable,
	input clear,
	input [3:0] d,
	output reg [3:0] q);always @(posedge clk or posedge clear) begin
	if (clear)
		q <= 4'b0000;
	else if (enable)
		q <= d;
end
endmodule