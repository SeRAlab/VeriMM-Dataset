module top_module (
	input clk,
	input reset,
	output reg [15:0] q);always @(posedge clk) begin
	if (reset)
		q <= 16'b0000000000000000;
	else
		q <= q ^ (q >> 1);
end

endmodule