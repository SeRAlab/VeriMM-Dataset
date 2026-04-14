module top_module(pcIn, src1RegIn, aluCalcIn, aluCondIn, destRegIn, regWrEnIn, memWrEnIn, isLWIn, opIn, dstMuxIn, clk, flush,
	pcOut, src1RegOut, aluCalcOut, aluCondOut, destRegOut, regWrEnOut, memWrEnOut, isLWOut, opOut, dstMuxOut);input flush, clk, regWrEnIn, memWrEnIn, isLWIn;
	input [31:0] src1RegIn, pcIn, aluCalcIn, aluCondIn;
	input [3:0]  destRegIn, opIn;
	input [1:0] dstMuxIn;
	output reg [31:0] src1RegOut = 0, pcOut = 0, aluCalcOut = 0, aluCondOut = 0;
	output reg regWrEnOut = 0, memWrEnOut = 0, isLWOut = 0;
	output reg [3:0] destRegOut = 0, opOut = 0;
	output reg [1:0] dstMuxOut = 0;
	
	always @(posedge clk) begin
		if (flush == 1'b1) begin
			{aluCalcOut, src1RegOut, destRegOut, regWrEnOut, memWrEnOut} <= 0;
		end
		else begin
			pcOut <= pcIn;
			aluCalcOut <= aluCalcIn;
			src1RegOut <= src1RegIn;
			destRegOut <= destRegIn;
			regWrEnOut <= regWrEnIn;
			memWrEnOut <= memWrEnIn;
			aluCondOut <= aluCondIn;
			isLWOut <= isLWIn;
			opOut <= opIn;
			dstMuxOut <= dstMuxIn;
		end
	end
endmodule