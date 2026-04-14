module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    output X
);wire A_low, A_high, B_low, B_high;

    assign A_low = ~(A1 | A2);
    assign A_high = A1 & A2;
    assign B_low = ~(B1 | B2);
    assign B_high = B1 & B2;

    assign X = (A_low & B_low) | (A_high & B_high);

endmodule