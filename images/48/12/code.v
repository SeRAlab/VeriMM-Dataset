module top_module(input [2:0] ALUControl, 
			input signed [31:0] SrcA, 
			input signed [31:0] SrcB, 
			output reg signed [31:0] ALUResult,
			output reg Zero);always @(*) begin
		case(ALUControl)
			0:  ALUResult = SrcA+SrcB; 
			1:  ALUResult = SrcA-SrcB; 
			2:  ALUResult = SrcA&SrcB; 
			4:  ALUResult = SrcA|SrcB; 
			5:  ALUResult = SrcA&~SrcB; 
			6:  ALUResult = SrcA|~SrcB; 
			7:  ALUResult = (SrcA<SrcB)?1:0; 
			default begin 
				ALUResult = 3'bxxx;
			end
		endcase
		
		Zero = (ALUResult==0) ? 1'b1 : 1'b0;
		
	end
	
endmodule