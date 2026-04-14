module top_module(
    input [3:0] A,
    input [3:0] B,
    input C,
    output [3:0] S
);wire [3:0] B_neg;
    assign B_neg = ~B + 1;

    assign S = (C == 0) ? A + B : A + B_neg;

endmodule