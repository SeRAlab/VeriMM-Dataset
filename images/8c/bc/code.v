module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] add,
    output [3:0] sub,
    output [3:0] mul,
    output [3:0] div
);// 4-bit adder
    assign add = A + B;

    // 4-bit subtractor
    assign sub = A - B;

    // 4-bit multiplier
    assign mul = A * B;

    // 4-bit divider
    assign div = A / B;

endmodule