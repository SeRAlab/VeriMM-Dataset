module top_module(PCAdd4, B, J, Jr, PCSrc, nextAddr);input [31:0] PCAdd4, B, J, Jr;
    input [2:0] PCSrc;
    output [31:0] nextAddr;

    function [31:0] select;
        input [31:0] PCAdd4, B, J, Jr;
        input [2:0] PCSrc;
        case(PCSrc)
            3'b000: select = PCAdd4;
            3'b001: select = B;
            3'b010: select = J;
            3'b011: select = J;
            3'b100: select = Jr;
            3'b101: select = Jr;
        endcase
    endfunction

    assign nextAddr = select (PCAdd4, B, J, Jr, PCSrc);endmodule