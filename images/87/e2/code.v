module top_module(
    input  [15:0] imm16,
    input         ExtType,
    output [31:0] imm32
);assign imm32 = {(imm16[15] == 1'b1 && ExtType == 1'b1) ? 16'hFFFF : 16'h0000, imm16};
endmodule