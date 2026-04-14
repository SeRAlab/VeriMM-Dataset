module top_module(imm16, extOp, dout);input                extOp;
    input       [15:0]   imm16;
    output reg  [31:0]   dout;

    always @ ( * ) begin
        case (extOp)
            0: dout = {16'h0000, imm16};
            1: dout = {{16{imm16[15]}}, imm16};
        endcase
    end
endmodule