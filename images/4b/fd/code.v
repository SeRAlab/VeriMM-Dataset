module top_module(
	input clk,
	input reset_n,
	input up,
	output reg [7:0] q);always @(posedge clk) begin
	if (!reset_n)
		q <= 8'b00000000;
	else if (up)
		q <= q + 1;
	else
		q <= q - 1;
end

endmodule