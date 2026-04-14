module top_module(Q, EX_MEM, MEM_WB, res_hi,res_lo,S, Y);input [31:0] Q, EX_MEM, MEM_WB,res_hi,res_lo;
    input [2:0] S;
    output [31:0] Y;

    function [31:0] select;
        input [31:0] Q, EX_MEM, MEM_WB,res_hi,res_lo;
        input [2:0] S;
        case(S)
            3'b000: select = Q;
            3'b001: select = EX_MEM;
            3'b010: select = MEM_WB;
            3'b100: select = res_hi;
            3'b101: select = res_lo;
        endcase
    endfunction
    assign Y = select (Q, EX_MEM, MEM_WB,res_hi,res_lo, S);endmodule