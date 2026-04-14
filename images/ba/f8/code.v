module M(
    input a,
    input b,
    output z
);
    assign z = (a ^ ~b);
endmodule

module N(
    input a,
    input b,
    output z
);
    assign z = (a ^ ~b);
endmodule

module top_module(
    input a,
    input b,
    output z
);
    wire m1_out, m2_out, n_out;
    wire and_out;

    M m1(.a(a), .b(b), .z(m1_out));
    M m2(.a(a), .b(b), .z(m2_out));
    N n1(.a(a), .b(b), .z(n_out));

    assign and_out = m1_out & n_out;
    assign z = and_out | m2_out;
endmodule