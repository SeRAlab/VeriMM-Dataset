module top_module (
	input g,
	input h,
	output i);
assign i = ~(g | h);
endmodule