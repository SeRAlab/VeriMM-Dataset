module top_module(rd,rt,RegDst,Y);input [4:0] rd,rt;
    input RegDst;
    output [4:0] Y;

    function [4:0] select;
        input [4:0] rd,rt;
        input RegDst;
        case(RegDst)
            1:select=rt;
            0:select=rd;
        endcase
    endfunction
    assign Y=select(rd,rt,RegDst);endmodule