module top_module(A, B, ALUCtr, ALUOut);input [31:0] A, B;
		input [2:0] ALUCtr;
		output [31:0] ALUOut;	
		
		assign ALUOut = (ALUCtr == 3'b000) ? A&B :
										  (ALUCtr == 3'b001) ? A|B :
										  (ALUCtr == 3'b010) ? A+B :
										  (ALUCtr == 3'b011) ? A-B :
										  (ALUCtr == 3'b100) ? $signed($signed(B)>>>A[4:0]) :
										  32'b0;

endmodule