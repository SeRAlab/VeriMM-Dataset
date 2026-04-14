module top_module (
	input u,
	input v,
	input w,
	output x);assign x = ((u & v) ^ w);
endmodule