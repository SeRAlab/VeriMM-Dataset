module top_module(
	input clk,
	input reset,
	input enable,
	output reg [5:0] q);always @(posedge clk) begin
	if (reset)
		q <= 6'b0;
	else if (enable) begin
		if (q == 6'b111111)
			q <= 6'b0;
		else
			q <= q + 1;
	end
end

endmodule