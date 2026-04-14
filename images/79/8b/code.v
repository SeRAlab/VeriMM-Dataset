module top_module(
    inst_i,
	imm_o
);input  [31 : 0] inst_i;
output [31 : 0] imm_o;

parameter Addi = 7'b0010011;
parameter Lw = 7'b0000011;
parameter Sw = 7'b0100011;
parameter Beq = 7'b1100011;

reg [11 : 0] imm_reg;
assign imm_o = {{20{imm_reg[11]}} , imm_reg[11 : 0]};

always @(inst_i)
begin
    if (inst_i[6:0] == Addi || inst_i[6:0] == Lw) 
    begin
        imm_reg <= inst_i[31 : 20];
    end
    if (inst_i[6:0] == Sw)
    begin
         imm_reg[11:5] <= inst_i[31 : 25];
         imm_reg[4:0] <= inst_i[11 : 7];
    end
    else if (inst_i[6:0] == Beq)
    begin
        imm_reg[3:0] <= inst_i[11 : 8];
        imm_reg[10] <= inst_i[7];
        imm_reg[9:4] <= inst_i[30 : 25];
        imm_reg[11] <= inst_i[31];
    end
end

endmodule