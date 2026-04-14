module P(
    input x,
    input y,
    input z,
    output r
);
    assign r = x & ~y & z;
endmodule

module Q(
    input x,
    input y,
    input z,
    output r
);
    assign r = x & ~y & z;
endmodule

module top_module(
    input x,
    input y,
    input z,
    output r
);
    wire p1_out, p2_out, q1_out, q2_out;
    wire and_out, or_out, xor_out;

    P p1(.x(x), .y(y), .z(z), .r(p1_out));
    P p2(.x(x), .y(y), .z(z), .r(p2_out));
    Q q1(.x(x), .y(y), .z(z), .r(q1_out));
    Q q2(.x(x), .y(y), .z(z), .r(q2_out));

    assign and_out = p1_out & q1_out;
    assign or_out = p2_out | q2_out;
    assign r = and_out ^ or_out;
endmodule