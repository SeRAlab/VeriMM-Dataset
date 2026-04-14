module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    output X
    );wire w1, w2, w3, w4, w5, w6, w7, w8, w9, w10, w11, w12;

    assign w1 = ~A & ~B & ~C & D & ~E;
    assign w2 = ~A & ~B & ~C & D & E;
    assign w3 = ~A & ~B & C & ~D & E;
    assign w4 = ~A & ~B & C & D & E;
    assign w5 = ~A & B & ~C & ~D & E;
    assign w6 = ~A & B & ~C & D & E;
    assign w7 = ~A & B & C & ~D & E;
    assign w8 = A & ~B & ~C & ~D & E;
    assign w9 = A & ~B & ~C & D & E;
    assign w10 = A & ~B & C & D & E;
    assign w11 = A & B & C & ~D & E;
    assign w12 = A & B & C & D & E;

    assign X = w1 | w2 | w3 | w4 | w5 | w6 | w7 | w8 | w9 | w10 | w11 | w12;
    
endmodule