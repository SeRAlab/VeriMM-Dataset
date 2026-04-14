module top_module(
	input clk,
	input reset,
	input enable,
	output reg [7:0] q);always @(posedge clk) begin
	if (reset)
		q <= 8'b11111111;
	else if (enable) begin
		if (q == 8'b0)
			q <= 8'b11111111;
		else
			q <= q - 1;
	end
end

endmodule