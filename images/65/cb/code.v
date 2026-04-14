module top_module(funct_i, ALUOp_i, ALUCtrl_o);input [5:0] funct_i;
	input [1:0] ALUOp_i;
	output [2:0] ALUCtrl_o;

	reg [2:0] ALUCtrl_o;
	
	localparam
		
		ALU_R_TYPE = 2'b11,
		ALU_ADD = 2'b00,
		ALU_SUB = 2'b01,
		ALU_OR = 2'b10,
		
		ADD = 3'b010,
		SUB = 3'b110,
		OR = 3'b001,
		AND = 3'b000,
		MUL = 3'b111;
	always @(funct_i or ALUOp_i) begin
		if (ALUOp_i == ALU_R_TYPE) begin
			case (funct_i)
			
			6'b100000:
				begin
					ALUCtrl_o <= ADD;
				end
			
			6'b100010:
				begin
					ALUCtrl_o <= SUB;
				end
			
			6'b100100:
				begin
					ALUCtrl_o <= AND;
				end
			
			6'b100101:
				begin
					ALUCtrl_o <= OR;
				end
			
			6'b011000:
				begin
					ALUCtrl_o <= MUL;
				end
			endcase
		end
		
		else if(ALUOp_i == ALU_ADD) begin
			ALUCtrl_o <=  ADD; 
		end
		else if(ALUOp_i == ALU_SUB) begin
			ALUCtrl_o <= SUB;			
		end
		else if(ALUOp_i == ALU_OR) begin
			ALUCtrl_o <= OR;		
		end
		else begin
			
			ALUCtrl_o <= ADD;
		end
	end
endmodule