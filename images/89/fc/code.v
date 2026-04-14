module top_module(
    X,
    A_N,
    B_N,
    C,
    D
);// Module ports
    output X;
    input A_N;
    input B_N;
    input C;
    input D;

    // Local signals
    wire nor_out;
    wire and_out;

    // Implementing the NOR of A_N and B_N
    nor nor_gate (nor_out, A_N, B_N);

    // Implementing the AND of C and D
    and and_gate (and_out, C, D);

    // Implementing the inverted AND of the NOR and the AND
    assign X = ~ (nor_out & and_out);

endmodule