module top_module (
	input a,
	input b,
	input c,
	output output_sop,
	output output_pos);assign output_sop = a&b | b&c | a&c;
	assign output_pos = (a|b|c) & (a|~b|~c);
endmodule