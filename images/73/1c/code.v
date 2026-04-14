module top_module(
	input clk,
	input clr,
	input ena,
	output reg [15:0] q);always @(posedge clk or posedge clr) begin
		if (clr)
			q <= 16'b0;
		else if (ena)
			q <= q + 1;
	end
endmodule