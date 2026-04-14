module binary_subtractor (
	input clk,
	input [3:0] a,
	input [3:0] b,
	input borrow_in,
	output reg [3:0] diff,
	output reg borrow_out);always @(posedge clk) begin
	{borrow_out, diff} <= a - b - borrow_in;
end

endmodule