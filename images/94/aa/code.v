module top_module (
	input w,
	input x,
	input y,
	input z,
	input v,
	output u);
assign u = (~(w | x | y | z)) | v;
endmodule