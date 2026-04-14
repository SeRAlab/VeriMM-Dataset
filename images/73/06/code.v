module top_module (
	input clk,
	input set,
	input [15:0] d,
	output reg [15:0] q);always @(posedge clk) begin
		if (set)
			q <= 16'b1111111111111111;
		else
			q <= d;
	end

endmodule