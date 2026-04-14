module top_module(
	input clk,
	input reset,
	input enable,
	output reg [13:0] q);always @(posedge clk) begin
	if (~reset)
		q <= 14'b0;
	else if (enable) begin
		if (q == 14'b11111111111111)
			q <= 14'b0;
		else
			q <= q + 1;
	end
end

endmodule