module top_module(
    Y,
    A,
    B,
    C,
    D,
    S
);output Y;
    input  A, B, C, D;
    input  [1:0] S;

    wire Y1, Y2, Y3, Y4;

    assign Y1 = (S == 2'b00) ? A : B;
    assign Y2 = (S == 2'b01) ? C : D;
    assign Y3 = (S == 2'b10) ? A : B;
    assign Y4 = (S == 2'b11) ? C : D;

    assign Y = (S == 2'b00 || S == 2'b01) ? Y1 : Y2;
    assign Y = (S == 2'b10 || S == 2'b11) ? Y3 : Y4;

endmodule