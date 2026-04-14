module top_module(
		ALU_Control, 
		operand_A, operand_B, 
		ALU_result, zero
);input [3:0]   ALU_Control; 
input [31:0]  operand_A ;
input [31:0]  operand_B ;
output reg zero; 
output reg [31:0] ALU_result;




always@(*)
begin
	case(ALU_Control)
		4'b0000: ALU_result = operand_A & operand_B;
		4'b0001: ALU_result = operand_A | operand_B;
		4'b0010: ALU_result = operand_A + operand_B;	
		4'b0110: ALU_result = operand_A - operand_B;
		4'b0111: ALU_result = (operand_A < operand_B) ? 1 : 0;
		4'b1100: ALU_result = ~(operand_A | operand_B);
		
		default: ALU_result = "HIHIHI";
	endcase 
	
	
	if(ALU_result == 32'b0)
	begin
		zero = 1;
	end
	else
	begin
		zero = 0;
	end
end



endmodule