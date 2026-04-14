module top_module(zero,signalExtend,brancheq,branchneq,sumOut,regOut,PC,PCout,control);input zero,brancheq,branchneq;
input [1:0] control;
input [31:0] PC, signalExtend, sumOut,regOut;
output reg[31:0] PCout;

always @(zero or brancheq or branchneq or control or PC or signalExtend or sumOut or regOut)

		case(control[1:0])
			 2'b00:
				begin
					if(branchneq == 1 && zero == 1)
						PCout = PC;
					else if(branchneq == 1 && zero == 0) 
								PCout = sumOut;
					else if(brancheq == 1 && zero == 1)
								PCout= sumOut;
					else if(brancheq == 1 && zero == 0)
								PCout= PC;
				 end
			 2'b01: PCout = signalExtend;
			 2'b10: PCout= PC;
			 2'b11: PCout= regOut;
		endcase
		
endmodule