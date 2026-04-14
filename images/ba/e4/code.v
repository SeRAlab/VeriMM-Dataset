module jk_flip_flop(
	input clk,
	input j,
	input k,
	output reg q);always @(posedge clk)
	begin
		if (j == 0 && k == 0)
			q <= q; // Hold state
		else if (j == 1 && k == 0)
			q <= 1; // Set state
		else if (j == 0 && k == 1)
			q <= 0; // Reset state
		else
			q <= ~q; // Toggle state
	end
endmodule