module M(
    input x,
    input y,
    input z,
    output p
);
    assign p = (x & y) | (~x & z);
endmodule

module N(
    input x,
    input y,
    input z,
    output p
);
    assign p = (x & y & z) | (~x & ~y & ~z);
endmodule

module top_module(
    input x,
    input y,
    input z,
    output p
);
    wire m1_out, m2_out, n1_out, n2_out;
    wire xor_out, or_out, and_out;

    M m1(.x(x), .y(y), .z(z), .p(m1_out));
    M m2(.x(x), .y(y), .z(z), .p(m2_out));
    N n1(.x(x), .y(y), .z(z), .p(n1_out));
    N n2(.x(x), .y(y), .z(z), .p(n2_out));

    assign xor_out = m1_out ^ n1_out;
    assign or_out = m2_out | n2_out;
    assign p = xor_out & or_out;
endmodule