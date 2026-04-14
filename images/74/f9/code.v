module top_module (
	input clk,
	input reset_n,
	output reg [7:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 8'b11111111;
	else
		q <= q - 1;
end

endmodule