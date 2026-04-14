module top_module(Source1, Source2, ALU_Ctrl, Result, Zero);input [15:0] Source1;
    input [15:0] Source2;
    input [3:0] ALU_Ctrl;
	output wire [15:0] Result;
	output wire Zero;
	
	
	
	
	
	
	
	assign Result = ALU_Ctrl[0] ? ((Source1 < Source2) ? 1 : 0) : (ALU_Ctrl[2] ? Source1 - Source2 : (ALU_Ctrl[1] ? Source1 + Source2 : Source1));
	assign Zero = (Source1==Source2);
    
    
endmodule