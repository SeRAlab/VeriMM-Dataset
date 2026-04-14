module top_module(
	input enable,
	input s,
	input r,
	output reg q);always @(*)
	if (enable) begin
		if (s && r)
			q <= 0;
		else if (s)
			q <= 1;
		else if (r)
			q <= 0;
	end

endmodule