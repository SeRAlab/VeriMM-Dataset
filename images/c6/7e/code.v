module my_and2 (
    input A,
    input B,
    output X
);

    // Local signals
    wire and_out;

    //  Name  Output      Other arguments
    and and_gate (and_out, A, B);

    assign X = and_out;

endmodule