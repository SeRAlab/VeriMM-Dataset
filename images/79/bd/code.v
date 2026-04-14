module top_module(BRANCH_IN,VAL_IN,BRANCH_OUT,VAL_OUT,RESET_2);input BRANCH_IN;
	input [31:0] VAL_IN;
	output reg [31:0] VAL_OUT;
	output reg BRANCH_OUT,RESET_2;
	
	always @(BRANCH_IN,VAL_IN) begin
		
		#1
	
		if (BRANCH_IN) begin  
			BRANCH_OUT = BRANCH_IN;
			VAL_OUT = VAL_IN;
			
			RESET_2 = 1;
		end
		
		else begin  
			BRANCH_OUT = BRANCH_IN;
			VAL_OUT = VAL_IN;
			
			RESET_2 = 0;
		end
		
	end
	
endmodule