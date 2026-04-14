module top_module(
    A,
    B,
    C,
    X
);input A;
    input B;
    input C;
    output X;

    // Signals
    wire A_lt_B;
    wire A_gt_B;
    wire A_eq_B;
    wire A_times_C;
    wire B_plus_C;
    wire A_and_B;

    // Comparator
    assign A_lt_B = (A < B);
    assign A_gt_B = (A > B);
    assign A_eq_B = (A == B);

    // Operations
    assign A_times_C = A_lt_B ? (A & C) : 1'b0;
    assign B_plus_C = A_gt_B ? (B | C) : 1'b0;
    assign A_and_B = A_eq_B ? (A & B) : 1'b0;

    // Output
    assign X = A_times_C | B_plus_C | A_and_B;

endmodule