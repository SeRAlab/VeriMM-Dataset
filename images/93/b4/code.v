module top_module(
	input clk,
	input reset,
	input enable,
	output reg [3:0] q);always @(posedge clk) begin
	if (~reset)
		q <= 4'b1111;
	else if (enable)
		q <= q - 1;
end

endmodule