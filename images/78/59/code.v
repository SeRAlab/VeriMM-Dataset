module top_module (
	input y,
	input z,
	output a);
assign a = ~(y & z);
endmodule