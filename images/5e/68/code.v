module top_module(
    input A,
    input B,
    output Y
);wire not_A, not_B, and_1, and_2, or_1;

    assign not_A = ~A;
    assign not_B = ~B;
    assign and_1 = not_A & B;
    assign and_2 = A & not_B;
    assign or_1 = and_1 | and_2;
    assign Y = ~or_1;

endmodule