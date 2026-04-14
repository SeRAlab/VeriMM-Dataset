module top_module(
    input  A1,
    input  A2,
    input  B1,
    input  B2,
    output Y
);wire and1_out, and2_out, or_out;

    // AND gate for A1 and A2 are high
    assign and1_out = A1 & A2;

    // AND gate for A1 and A2 are low
    assign and2_out = ~A1 & ~A2;

    // OR gate for the output of the two AND gates
    assign or_out = and1_out | and2_out;

    // Multiplexer to select between B1 and B2 based on the output of the OR gate
    assign Y = or_out ? B1 : B2;

endmodule