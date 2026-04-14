module top_module(
   input [31:0]RD1_out,
	input [31:0]ALUOutM,
	input [31:0]ResultW,
   input [1:0]ForwardAE,
	output [31:0]SrcAE
);assign SrcAE = (ForwardAE==2'd0)?RD1_out:(ForwardAE==2'd1)?ResultW:ALUOutM;
endmodule