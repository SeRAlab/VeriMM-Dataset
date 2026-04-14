module top_module (
	input clk,
	input reset,
	input j,
	input k,
	output reg q);

	always @(posedge clk or posedge reset) begin
		if (reset)
			q <= 0;
		else if (j && k)
			q <= ~q;
		else if (j)
			q <= 1;
		else if (k)
			q <= 0;
	end
endmodule