module top_module (
	input clk,
	input reset,
	input enable,
	input [3:0] data,
	output reg [3:0] q);always @(posedge clk) begin
	if (reset)
		q <= 4'b0;
	else if (enable)
		q <= data;
end

endmodule