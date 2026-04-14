module I(
    input p,
    input q,
    output v
);
    assign v = ~(p & q);
endmodule

module J(
    input p,
    input q,
    output v
);
    assign v = ~(p & q);
endmodule

module top_module(
    input p,
    input q,
    output v
);
    wire i1_out, i2_out, j_out;
    wire xor_out;

    I i1(.p(p), .q(q), .v(i1_out));
    I i2(.p(p), .q(q), .v(i2_out));
    J j1(.p(p), .q(q), .v(j_out));

    assign xor_out = i1_out ^ j_out;
    assign v = xor_out | i2_out;
endmodule