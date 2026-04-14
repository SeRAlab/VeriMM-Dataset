module top_module( input [31:0] Multiplexer_Instruction, 
							 input [31:0] Jump_Instruction,
							 input Jump_Control,
							 output [31:0] New_PC
							 );reg [31:0] temp;

	always @(*) begin
		case (Jump_Control) 
			0: temp <= Multiplexer_Instruction;
			1: temp <= Jump_Instruction;
		endcase 
	end
	
	assign New_PC = temp;
endmodule