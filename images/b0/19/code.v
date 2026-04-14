module counter_10bit(
	input clk,
	input reset_n,
	output reg [9:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 10'b0;
	else
		q <= q + 5;
end

endmodule