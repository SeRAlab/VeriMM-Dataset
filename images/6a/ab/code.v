module E(
    input x,
    input y,
    output z
);
    assign z = x ^ y;
endmodule

module F(
    input x,
    input y,
    output z
);
    assign z = x ^ y;
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire e1_out, e2_out, f1_out, f2_out;
    wire and_out, or_out;

    E e1(.x(x), .y(y), .z(e1_out));
    E e2(.x(x), .y(y), .z(e2_out));
    F f1(.x(x), .y(y), .z(f1_out));
    F f2(.x(x), .y(y), .z(f2_out));

    assign and_out = e1_out & f1_out;
    assign or_out = e2_out | f2_out;

    assign z = and_out ^ or_out;
endmodule