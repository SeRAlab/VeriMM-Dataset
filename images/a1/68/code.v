module top_module(
    input a,
    input b,
    input c,
    output y
);wire not_a, not_b, not_c, and1, and2, or1;

    // Invert inputs
    not(not_a, a);
    not(not_b, b);
    not(not_c, c);

    // AND gates
    and(and1, not_a, not_b);
    and(and2, not_c, and1);

    // OR gate
    or(or1, and2, and2, and2);

    // Invert output
    not(y, or1);

endmodule