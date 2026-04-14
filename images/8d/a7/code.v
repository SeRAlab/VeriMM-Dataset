module top_module (
	input [25:0] t,
	output [24:0] out_eq3,
	output [24:0] out_nand3);assign out_eq3 = ~(t[24:0] ^ t[25:1]);
	assign out_nand3 = ~(t[24:0] & t[23:0]);
	
endmodule