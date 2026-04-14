module top_module(EXT,Qb_FORWARD,S,Y);input [31:0] EXT,Qb_FORWARD;
    input S;
    output [31:0] Y;

    function [31:0] select;
        input [31:0] EXT,Qb_FORWARD;
        input S;
        case(S)
            0:select=EXT;
            1:select=Qb_FORWARD;
        endcase
    endfunction
    assign Y=select(EXT,Qb_FORWARD,S);endmodule