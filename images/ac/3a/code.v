module top_module(
    instr_op_i,
	RegWrite_o,
	ALU_op_o,
	ALUSrc_o,
	RegDst_o,
	Branch_o
	);input  [6-1:0] instr_op_i;

output         RegWrite_o;
output [3-1:0] ALU_op_o;
output         ALUSrc_o;
output         RegDst_o;
output         Branch_o;
 

reg    [3-1:0] ALU_op_o;

wire           ALUSrc_o;
wire           RegWrite_o;
wire           RegDst_o;
wire           Branch_o;

wire rtype, beq, addi, slti;



always@(instr_op_i)begin
    case(instr_op_i[5:0])
        0: ALU_op_o   <= 3'b010; 
        4: ALU_op_o   <= 3'b001; 
        8: ALU_op_o   <= 3'b101; 
        10: ALU_op_o   <= 3'b110; 
    endcase
end


assign rtype = (instr_op_i == 0);
assign beq = (instr_op_i == 4);
assign addi = (instr_op_i == 8);
assign slti = (instr_op_i == 12);

assign ALUSrc_o = (addi | slti);
assign RegWrite_o = (rtype | addi | slti);
assign RegDst_o = rtype;
assign Branch_o = beq;






endmodule