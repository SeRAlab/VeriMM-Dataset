module top_module( 	ALUOp,
		src1,
		src2,
		shamt,
		ALU_result,
		Zero
	   	);parameter bit_size = 32;
	
	input [3:0] 		ALUOp;
	input [4:0] 		shamt;
	input [bit_size-1:0]	src1;
	input [bit_size-1:0]	src2;
	
	output[bit_size-1:0]	ALU_result;
	output 			Zero;
			
	reg   [bit_size-1:0]	ALU_result;

	localparam ADD = 4'b0000;
	localparam SUB = 4'b0001;
	localparam AND = 4'b0010;
	localparam OR  = 4'b0011;
	localparam XOR = 4'b0100;
	localparam NOR = 4'b0101;
	localparam SLT = 4'b0110;
	localparam SLL = 4'b0111;
	localparam SRL = 4'b1000;

	assign Zero = (ALU_result == 0)? 0 : 1;

	always@(ALUOp, shamt, src1, src2)
	begin
		case(ALUOp)
			AND : ALU_result = src1 & src2;
			OR  : ALU_result = src1 | src2;
			XOR : ALU_result = src1 ^ src2;
			NOR : ALU_result = ~(src1 | src2);
			ADD : ALU_result = src1 + src2;
			SUB : ALU_result = src1 - src2;
			SLT : ALU_result = ( src1 < src2)? 1 :0;
			SLL : ALU_result = src2 << shamt;
			SRL : ALU_result = src2 >> shamt;
		endcase
	end

endmodule