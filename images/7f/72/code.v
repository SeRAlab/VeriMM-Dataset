module top_module (
	input [21:0] q,
	output [20:0] out_or3,
	output [20:0] out_xor3);assign out_or3 = q[20:0] | q[21:1];
	assign out_xor3 = q[20:0] ^ q[21:1];
	
endmodule