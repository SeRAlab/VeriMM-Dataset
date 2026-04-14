module top_module(AluData, MemoryData, MemToReg, Halt, WriteData);input [15:0] AluData, MemoryData;
   input 	MemToReg;
   input 	Halt;   
   
   output 	[15:0] WriteData;

   assign WriteData = MemToReg ? MemoryData : AluData;
endmodule