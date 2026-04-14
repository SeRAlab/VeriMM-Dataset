module top_module(
    input A1,
    input A2,
    input B1_N,
    output Y
);wire not_B1_N;
    wire A1_AND_A2;

    // Implement NOT gate for B1_N
    not U1 (not_B1_N, B1_N);

    // Implement AND gate for A1 and A2
    and U2 (A1_AND_A2, A1, A2);

    // Implement AND gate for A1_AND_A2 and not_B1_N
    and U3 (Y, A1_AND_A2, not_B1_N);

endmodule