module top_module(
    input [31:0] ins_d,
    output [5:0] op_d,func_d,
    output [4:0] rs_d,rt_d,rd_d,shamt_d,
    output [15:0] imm_d
    );assign op_d = ins_d[31:26];
    assign func_d = ins_d[5:0];
    assign rs_d = ins_d[25:21];
    assign rt_d = ins_d[20:16];
    assign rd_d = ins_d[15:11];
    assign shamt_d = ins_d[10:6];
    assign imm_d = ins_d[15:0];
endmodule