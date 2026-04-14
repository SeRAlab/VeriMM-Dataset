module top_module (
	input [7:0] h,
	output [6:0] out_eq,
	output [6:0] out_nand);assign out_eq = ~(h[6:0] ^ h[7:1]);
	assign out_nand = ~(h[6:0] & h[5:0]);
	
endmodule