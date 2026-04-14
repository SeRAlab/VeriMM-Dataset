module top_module(
    A,
    B,
    C,
    D,
    Y0,
    Y1,
    Y2,
    Y3
);input [3:0] A, B, C, D;
    output [3:0] Y0, Y1, Y2, Y3;

    wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12, w13, w14, w15;

    // Implementing the truth table
    assign w1 = ~A & ~B & ~C & ~D;
    assign w2 = ~A & ~B & ~C & D;
    assign w3 = ~A & ~B & C & ~D;
    assign w4 = ~A & ~B & C & D;
    assign w5 = ~A & B & ~C & ~D;
    assign w6 = ~A & B & ~C & D;
    assign w7 = ~A & B & C & ~D;
    assign w8 = ~A & B & C & D;
    assign w9 = A & ~B & ~C & ~D;
    assign w10 = A & ~B & ~C & D;
    assign w11 = A & ~B & C & ~D;
    assign w12 = A & ~B & C & D;
    assign w13 = A & B & ~C & ~D;
    assign w14 = A & B & ~C & D;
    assign w15 = A & B & C & ~D;

    // Assigning outputs
    assign Y0 = w1 | w2 | w3 | w4 | w5 | w6 | w7 | w8;
    assign Y1 = w5 | w6 | w7 | w8 | w9 | w10 | w11 | w12;
    assign Y2 = w3 | w4 | w7 | w8 | w11 | w12 | w13 | w14;
    assign Y3 = w2 | w4 | w6 | w8 | w10 | w12 | w14 | w15;

endmodule