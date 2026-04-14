module top_module(
    input a,
    input b,
    input sel,
    output y
);wire not_sel;
    wire a_and_sel;
    wire b_and_not_sel;

    // Invert the select signal
    not(not_sel, sel);

    // AND gate between a and inverted select signal
    and(a_and_sel, a, not_sel);

    // AND gate between b and select signal
    and(b_and_not_sel, b, sel);

    // OR gate between the two AND gates
    or(y, a_and_sel, b_and_not_sel);

endmodule