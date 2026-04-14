module top_module (
	input clk,
	input reset,
	input up,
	output reg [3:0] q);always @(posedge clk) begin
	if (reset)
		q <= 0;
	else if (up)
		q <= q + 1;
	else
		q <= q - 1;
end

endmodule