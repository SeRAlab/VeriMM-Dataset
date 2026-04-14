module top_module (
	input a,
	input b,
	input c,
	output out_sop,
	output out_pos);assign out_sop = b & c;
assign out_pos = b | c;
endmodule