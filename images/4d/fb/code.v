module top_module (
	input clk,
	input enable,
	output reg [2:0] q);always @(posedge clk) begin
	if (enable)
		q <= q + 1;
end

endmodule