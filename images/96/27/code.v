module top_module (
	input [13:0] n,
	output [12:0] out_and2,
	output [12:0] out_nor2);assign out_and2 = n[12:0] & n[13:1];
	assign out_nor2 = ~(n[12:0] | n[13:1]);
	
endmodule