module top_module(ReadData, ALUresult, MemToReg, MuxOut);input [31:0] ReadData, ALUresult;
	input MemToReg;
	output reg [31:0] MuxOut;
	
	always @ (*)
		begin
			if (MemToReg)
				MuxOut = ReadData;
			else
				MuxOut = ALUresult;
		end
		
endmodule