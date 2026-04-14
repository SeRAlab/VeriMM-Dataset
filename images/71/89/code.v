module top_module(
    input [3:0] A,
    input [3:0] B,
    input sub,
    output [3:0] S
);wire [3:0] B_neg;
    assign B_neg = ~B + 1;

    wire [3:0] add_out;
    assign add_out = A + B;

    wire [3:0] sub_out;
    assign sub_out = A + B_neg;

    assign S = sub ? sub_out : add_out;

endmodule