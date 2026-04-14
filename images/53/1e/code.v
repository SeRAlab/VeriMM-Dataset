module top_module(
	input clk,
	output reg [2:0] q);

always @(negedge clk) begin
	q <= q + 1;
end

endmodule