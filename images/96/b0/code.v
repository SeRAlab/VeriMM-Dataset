module top_module (
	input i,
	input j,
	input k,
	output l);assign l = (~((i & j) | k));
endmodule