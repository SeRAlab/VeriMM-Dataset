module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    output Y
);wire a1_a2_high;
    wire b1_b2_high;

    assign a1_a2_high = A1 & ~A2;
    assign b1_b2_high = B1 & ~B2;

    assign Y = a1_a2_high | b1_b2_high;

endmodule