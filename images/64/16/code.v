module top_module(lb,lbu,lh,lhu,lw,load_option,ext_Dout);input [31:0] lb,lbu,lh,lhu,lw;
    input [2:0]load_option;
    output [31:0] ext_Dout;

    function [31:0] select;
        input [31:0]lb,lbu,lh,lhu,lw;
        input [2:0]load_option;
        case(load_option)
            3'b000:select=lw;
            3'b101:select=lb;
            3'b001:select=lbu;
            3'b111:select=lh;
            3'b011:select=lhu;
        endcase
    endfunction
    assign ext_Dout=select(lb,lbu,lh,lhu,lw,load_option);endmodule