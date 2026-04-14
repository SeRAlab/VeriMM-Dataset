module top_module (
	input [23:0] s,
	output [22:0] out_and3,
	output [22:0] out_nor3);assign out_and3 = s[22:0] & s[23:1];
	assign out_nor3 = ~(s[22:0] | s[23:1]);
	
endmodule