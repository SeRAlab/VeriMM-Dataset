module logic_gate (
    // inputs
    input A1,
    input A2,
    input B1,

    // output
    output X
);

    wire a_or_b;
    or gate (a_or_b, A1, A2);

    assign X = a_or_b & ~B1;

endmodule