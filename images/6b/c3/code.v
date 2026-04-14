module M(
    input x,
    input y,
    output z
);
    assign z = x & y;
endmodule

module N(
    input x,
    input y,
    output z
);
    assign z = x & y;
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire m1_out, m2_out, n1_out, n2_out;
    wire or_out, xor_out;

    M m1(.x(x), .y(y), .z(m1_out));
    M m2(.x(x), .y(y), .z(m2_out));
    N n1(.x(x), .y(y), .z(n1_out));
    N n2(.x(x), .y(y), .z(n2_out));

    assign or_out = m1_out | n1_out;
    assign xor_out = m2_out ^ n2_out;

    assign z = or_out & xor_out;
endmodule