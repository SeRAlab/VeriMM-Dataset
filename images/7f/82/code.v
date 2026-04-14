module top_module(ALU_Result, Mem_Data, Sel, WB);input [15:0] 	ALU_Result;
	input [15:0] 	Mem_Data;
	input 			Sel;

	output [15:0] 	WB;

	assign WB = Sel ? Mem_Data : ALU_Result;

endmodule