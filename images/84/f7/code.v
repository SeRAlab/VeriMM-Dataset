module top_module(
input inMemRead,inPCSrc,
input [4:0] inID_EXRt,inIF_IDRs,inIF_IDRt,inRegRtMEM,
output reg outPCWrite,outIF_IDWrite,outIF_Flush,outEX_Flush,outStall
    );always@ (*)
begin			
			if(inPCSrc) 
				begin
					outPCWrite = 1; 
					outIF_IDWrite = 1; 
					outStall=0; 
					outIF_Flush = 1; 
					outEX_Flush = 0; 
				end
			
			else if(inMemRead
			& ((inID_EXRt == inIF_IDRs)
				| (inID_EXRt == inIF_IDRt))) 
				begin
					outPCWrite = 0;
					outIF_IDWrite = 0;
					outStall = 0;
					outIF_Flush  = 0;
					outEX_Flush = 0;
				end
			
			else 
				begin
					outPCWrite = 1;
					outIF_IDWrite = 1;
					outStall = 1;
					outIF_Flush = 0;
					outEX_Flush = 0;
				end	
end

endmodule