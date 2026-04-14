module top_module(
	input x, y, s,
	output m);assign m = (~s&x)|(s&y);
	
endmodule