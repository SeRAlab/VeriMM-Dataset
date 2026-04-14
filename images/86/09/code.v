module top_module(
	input a,
	input b,
	input c,
	output s,
	output co
    );assign s = a ^ b ^ c;
assign co = (a & b) | (a & c) | (b & c);


endmodule