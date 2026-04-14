module top_module(
    input A,
    input B,
    output Y
);wire not_A, not_B;

    // Implementing NOR gate using NOT gates
    assign not_A = ~(A);
    assign not_B = ~(B);

    // Final output: NOR of A and B
    assign Y = ~(not_A | not_B);

endmodule