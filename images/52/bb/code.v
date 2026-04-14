module top_module(
    input A,
    input B,
    input SEL,
    output Y
);wire not_SEL;
    wire A_and_SEL;
    wire B_and_not_SEL;

    assign not_SEL = ~SEL;
    assign A_and_SEL = A & SEL;
    assign B_and_not_SEL = B & not_SEL;

    assign Y = A_and_SEL | B_and_not_SEL;

endmodule