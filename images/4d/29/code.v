module top_module(
    input [15:0] imm16,
    input extcon,
    output [31:0] extout
    );assign extout = {{16{extcon && imm16[15]}}, imm16};
endmodule