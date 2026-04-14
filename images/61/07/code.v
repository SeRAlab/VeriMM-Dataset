module top_module(
    input [31:0] ALU_DA,
    input [31:0] ALU_DB,
    input [1:0] ALUOp,
    output reg [31:0] ALU_DC,
    output reg ALU_Zero
    );always @(*)
		begin
			case(ALUOp)
				2'b00:ALU_DC = ALU_DA + ALU_DB;
				2'b01:ALU_DC = ALU_DA - ALU_DB;
				2'b10:ALU_DC = ALU_DA & ALU_DB;
				2'b11:ALU_DC = ALU_DA | ALU_DB;
			endcase
			if(ALU_DC)
				ALU_Zero = 0;
			else
				ALU_Zero = 1;
		end


endmodule