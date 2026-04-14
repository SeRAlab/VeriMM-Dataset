module top_module(
	input clk,
	input enable,
	input [31:0] max_count,
	output reg [31:0] q);always @(posedge clk) begin
	if (enable) begin
		if (q == max_count)
			q <= 32'b0;
		else
			q <= q + 1;
	end
end
endmodule