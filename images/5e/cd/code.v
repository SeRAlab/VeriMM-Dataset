module top_module (
	input [4:0] a, b,
	output reg gt);always_comb begin
		if (a > b)
			gt = 1;
		else
			gt = 0;
	end

endmodule