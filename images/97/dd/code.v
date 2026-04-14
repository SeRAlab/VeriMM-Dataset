module top_module(
    A,
    B,
    C,
    X
);input A;
    input B;
    input C;
    output X;

    wire AB;
    wire AC;
    wire BC;

    // Find the largest value between A and B
    assign AB = (A > B) ? 1'b1 : 1'b0;

    // Find the largest value between A and C
    assign AC = (A > C) ? 1'b1 : 1'b0;

    // Find the largest value between B and C
    assign BC = (B > C) ? 1'b1 : 1'b0;

    // Output the largest value among A, B, and C
    assign X = (AB & AC) | (AB & BC) | (AC & BC) ? 1'b1 : 1'b0;

endmodule