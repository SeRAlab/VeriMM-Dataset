module top_module(
    input wire [31:0] imm,
    input wire [31:0] pc,
    output wire [31:0] hik
    );assign hik = imm + pc;

endmodule