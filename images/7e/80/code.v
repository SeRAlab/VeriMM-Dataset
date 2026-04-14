module top_module(
	input clk,
	input set,
	input reset,
	input [3:0] data,
	output reg [3:0] q);always @(posedge clk) begin
	if (reset)
		q <= 4'b0000;
	else if (set)
		q <= 4'b1111;
	else
		q <= data;
end
endmodule