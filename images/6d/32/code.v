module top_module (
	input x,
	input y,
	input z,
	input w,
	input u,
	output v);
assign v = (x ^ y ^ z ^ w) & u;
endmodule