module top_module(
        input [31:0] ins_i ,
        output [4:0] rs_o,
        output [4:0] rt_o,
        output [4:0] rd_o
    );assign rs_o = ins_i[25:21];
    assign rt_o = ins_i[20:16];
    assign rd_o = ins_i[15:11];endmodule