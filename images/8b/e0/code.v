module top_module(
	input clk,
	input mem2reg,
	input regwrite,
	
	input memwrite,
	input memread,
	
	input zero,
	input [4:0] regdst,
	input [31:0] readdata2,
	input [31:0] aluresult,
	input [31:0] add_pc_offset,
	
	output reg mem2reg_O,
	output reg regwrite_O,
	
	output reg memwrite_O,
	output reg memread_O,
	
	output reg zero_O,
	output reg [4:0] regdst_O,
	output reg [31:0] readdata2_O,
	output reg [31:0] aluresult_O,
	output reg [31:0] add_pc_offset_O
);always @(posedge clk)
begin	 
	mem2reg_O <= mem2reg;
	regwrite_O <= regwrite;
	
	memwrite_O <= memwrite;
	memread_O <= memread;
	
	zero_O <= zero;
	regdst_O <= regdst;
	readdata2_O <= readdata2;
	aluresult_O <= aluresult;
	add_pc_offset_O <= add_pc_offset;
end
endmodule