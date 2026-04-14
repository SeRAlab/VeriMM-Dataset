module top_module(MEM_Data, Lo_ReadData, Hi_ReadData, MEM_Result, EXE_MEM_LoRead, EXE_MEM_HiRead, MEM_memWrite);input [63:0] Lo_ReadData, Hi_ReadData, MEM_Result;
	input EXE_MEM_LoRead, EXE_MEM_HiRead, MEM_memWrite;
	

	output reg [63:0] MEM_Data;
	
	always @(*)
		begin
			if(EXE_MEM_LoRead)
				MEM_Data <= Lo_ReadData;
			
			else if(EXE_MEM_HiRead)
				MEM_Data <= Hi_ReadData;
				
			else 
				MEM_Data <= MEM_Result;
		end
		
endmodule