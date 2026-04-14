module top_module(
	input clk,
	input reset,
	output reg [19:0] q);always @(posedge clk) begin
	if (reset)
		q <= 20'b0;
	else
		q <= q + 4;
end

endmodule