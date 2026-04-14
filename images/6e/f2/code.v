module top_module(
    A,
    B,
    CI,
    SUM,
    COUT_N
);input A;
    input B;
    input CI;
    output SUM;
    output COUT_N;

    wire S1;
    wire C1;
    wire C2;

    assign S1 = A ^ B;
    assign SUM = S1 ^ CI;
    assign C1 = A & B;
    assign C2 = CI & S1;
    assign COUT_N = C1 | C2;

endmodule