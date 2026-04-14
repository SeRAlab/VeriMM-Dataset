module top_module (
	input [17:0] p,
	output [16:0] out_eq2,
	output [16:0] out_nand2);assign out_eq2 = ~(p[16:0] ^ p[17:1]);
	assign out_nand2 = ~(p[16:0] & p[15:0]);
	
endmodule