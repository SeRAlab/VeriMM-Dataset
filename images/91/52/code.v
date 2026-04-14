module top_module( instr_op_i, RegWrite_o,	ALUOp_o, ALUSrc_o, RegDst_o );input	[6-1:0] instr_op_i;
output			RegWrite_o;
output	[3-1:0] ALUOp_o;
output			ALUSrc_o;
output			RegDst_o;
 

wire	[3-1:0] ALUOp_o;
wire			ALUSrc_o;
wire			RegWrite_o;
wire			RegDst_o;



reg	[3-1:0] aluOp_o;
reg	aluSrc_o;
reg	regWrite_o;
reg	regDst_o;

always @(*) begin
	case (instr_op_i)
		6'b000000: begin 
			aluOp_o = 3'b010;
			aluSrc_o = 0;
			regWrite_o = 1;
			regDst_o = 1;
		end
		6'b001000: begin 
			aluOp_o = 3'b001;
			aluSrc_o = 1;
			regWrite_o = 1;
			regDst_o = 0;
		end
	endcase
end

assign ALUOp_o = aluOp_o;
assign ALUSrc_o = aluSrc_o;
assign RegWrite_o = regWrite_o;
assign RegDst_o = regDst_o;

endmodule