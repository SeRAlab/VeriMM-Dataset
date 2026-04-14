module down_counter(
	input clk,
	input reset,
	output reg [7:0] q);always @(posedge clk) begin
	if (reset)
		q <= 8'b11111111;
	else
		q <= q - 1;
end

endmodule