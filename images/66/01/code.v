module counter_12bit(
	input clk,
	input reset,
	output reg [11:0] q);always @(posedge clk) begin
	if (reset)
		q <= 12'b0;
	else
		q <= q + 4;
end

endmodule