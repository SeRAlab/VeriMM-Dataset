module top_module (
	input a,
	input b,
	input c,
	output out_sop,
	output out_pos);assign out_sop = ~a&b | a&b&c;
	assign out_pos = (~a | b) & (a | b | c);
endmodule