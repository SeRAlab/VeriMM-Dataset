module J(
    input p,
    input q,
    output z
);
    assign z = (p ^ q);
endmodule

module K(
    input p,
    input q,
    output z
);
    assign z = (p ^ q);
endmodule

module top_module(
    input p,
    input q,
    output z
);
    wire j1_out, j2_out, k1_out, k2_out;
    wire or_out, and_out;

    J j1(.p(p), .q(q), .z(j1_out));
    J j2(.p(p), .q(q), .z(j2_out));
    K k1(.p(p), .q(q), .z(k1_out));
    K k2(.p(p), .q(q), .z(k2_out));

    assign or_out = j1_out | k1_out;
    assign and_out = j2_out & k2_out;

    assign z = or_out ^ and_out;
endmodule