module enable_counter(
	input clk,
	input reset,
	input enable,
	output reg [5:0] q);always @(posedge clk) begin
	if (reset)
		q <= 6'b0;
	else if (enable)
		q <= q + 1;
end

endmodule