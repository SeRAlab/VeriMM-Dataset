module top_module(op, memtoreg, memwrite, branch, alusrc, regdst, regwrite, jump, aluop);input [5:0] op;
    output memtoreg;
    output memwrite;
    output branch;
    output alusrc;
    output regdst;
    output regwrite;
    output jump;
    output [1:0] aluop;

    wire [8:0] controls;

    assign {regwrite, regdst, alusrc, branch, memwrite, memtoreg, jump, aluop} = controls;

    assign controls = decode(op);

    function [8:0] decode(input [5:0] op);
    begin
        case(op)
        6'b000000: decode = 9'b110000010;
        6'b100011: decode = 9'b101001000;
        6'b101011: decode = 9'b001010000;
        6'b000100: decode = 9'b000100001;
        6'b001000: decode = 9'b101000000;
        6'b000010: decode = 9'b000000100;
        default:   decode = 9'bxxxxxxxxx;
        endcase
    end
    endfunction

endmodule