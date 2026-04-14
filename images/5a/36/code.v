module top_module(
	input clk,
	input reset,
	input [31:0] d,
	output reg [31:0] q);always @(posedge clk) begin
	if (reset)
		q <= 32'b0;
	else
		q <= d;
end

endmodule