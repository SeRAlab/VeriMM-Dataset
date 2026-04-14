module bitwise_and (
	input clk,
	input [3:0] x,
	input [3:0] y,
	output reg [3:0] z);always @(posedge clk) begin
		z <= x & y;
	end

endmodule