module top_module(
    input [15:0]imm16,
    input ExtSel,
    output [31:0]imm32
);assign imm32 = ExtSel? {{16{imm16[15]}},imm16}:{16'b0,imm16};
endmodule