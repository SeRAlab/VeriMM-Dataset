module top_module(
	
	input clk,
	input syscallFlag2_i,
	input [31:0] dataInput_i,
	input [31:0] dataOutput_i,
	input [5:0] aluCtrl2_i,
	input [4:0] writeReg2_i,
	input memtoReg2_i,
	input regWrite2_i,
	input link2_i,

	output reg syscallFlag3_o,
	output reg [31:0] dataInput1_o,
	output reg [31:0] dataOutput1_o,
	output reg [5:0] aluCtrl3_o,
	output reg [4:0] writeReg3_o,
	output reg memtoReg3_o,
	output reg regWrite3_o,
	output reg link3_o
);always @ (posedge clk)
begin 
	syscallFlag3_o <= syscallFlag2_i;
	dataInput1_o <= dataInput_i;
	dataOutput1_o <= dataOutput_i;
	aluCtrl3_o <= aluCtrl2_i;
	writeReg3_o <= writeReg2_i;
	memtoReg3_o <= memtoReg2_i;
	regWrite3_o <= regWrite2_i;
	link3_o <= link2_i;

end

endmodule