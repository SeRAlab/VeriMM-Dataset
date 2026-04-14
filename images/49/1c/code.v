module top_module(
R2, extend, shift_num,
AluSrc, shift, ComBranch, syscall,
Y
    );input [31:0] R2, extend, shift_num;
    input AluSrc, shift, ComBranch, syscall;
    output [31:0] Y;

    wire [31:0] a, b, c;

    assign a = (AluSrc) ? extend : R2;
    assign b = (shift) ? shift_num : a;
    assign c = (ComBranch) ? 0 : b;
    assign Y = (syscall) ? 10 : c;
endmodule