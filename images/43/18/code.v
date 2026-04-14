module P(
    input m,
    input n,
    output z
);
    assign z = ~(m | n);
endmodule

module Q(
    input m,
    input n,
    output z
);
    assign z = ~(m | n);
endmodule

module top_module(
    input m,
    input n,
    output z
);
    wire p1_out, p2_out, q1_out, q2_out;
    wire and_out, xor_out;

    P p1(.m(m), .n(n), .z(p1_out));
    P p2(.m(m), .n(n), .z(p2_out));
    Q q1(.m(m), .n(n), .z(q1_out));
    Q q2(.m(m), .n(n), .z(q2_out));

    assign and_out = p1_out & q1_out;
    assign xor_out = p2_out ^ q2_out;

    assign z = and_out | xor_out;
endmodule