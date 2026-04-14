module top_module(imm, inst);output [31:0] imm;
    input [15:0] inst;
    assign imm[31:16] = {16{inst[15]}};
    assign imm[15:0] = inst[15:0];endmodule