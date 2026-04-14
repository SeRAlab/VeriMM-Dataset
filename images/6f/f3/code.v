module top_module (
	input clk,
	input reset,
	output reg [13:0] q);always @(posedge clk or posedge reset) begin
	if (reset)
		q <= 14'b11111111111111;
	else
		q <= q - 1;
end

endmodule