module down_counter_14bit(
	input clk,
	input reset_n,
	output reg [13:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 14'b11111111111111;
	else
		q <= q - 2;
end

endmodule