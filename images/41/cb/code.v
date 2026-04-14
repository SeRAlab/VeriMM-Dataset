module top_module(
    A,
    B,
    X,
    VPWR,
    VGND
);input A;
    input B;
    output X;
    input VPWR;
    input VGND;

    wire not_A;
    wire not_B;
    wire A_and_not_B;
    wire not_A_and_B;

    // NOT gate for A
    assign not_A = ~A;

    // NOT gate for B
    assign not_B = ~B;

    // AND gate for A and not B
    assign A_and_not_B = A & not_B;

    // AND gate for not A and B
    assign not_A_and_B = not_A & B;

    // OR gate for the final output X
    assign X = A_and_not_B | not_A_and_B;

endmodule