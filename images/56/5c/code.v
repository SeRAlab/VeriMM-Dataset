module top_module (
	input clk,
	input reset,
	input enable,
	output reg [2:0] q);always @(posedge clk) begin
	if (reset)
		q <= 3'd7;
	else if (enable)
		q <= (q == 3'd0) ? 3'd7 : q - 1;
end

endmodule