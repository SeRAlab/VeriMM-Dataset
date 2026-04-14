module top_module(
	input en,
	input reset,
	input d,
	output reg q);always @(*)
	if (reset)
		q <= 0;
	else if (en)
		q <= d;

endmodule