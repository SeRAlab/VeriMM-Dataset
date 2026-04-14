module E(
    input x,
    input y,
    output u
);
    assign u = x ~^ y;
endmodule

module F(
    input x,
    input y,
    output u
);
    assign u = x ~^ y;
endmodule

module top_module(
    input x,
    input y,
    output u
);
    wire e1_out, e2_out, f1_out, f2_out;
    wire xor_out, or_out;

    E e1(.x(x), .y(y), .u(e1_out));
    E e2(.x(x), .y(y), .u(e2_out));
    F f1(.x(x), .y(y), .u(f1_out));
    F f2(.x(x), .y(y), .u(f2_out));

    assign xor_out = e1_out ^ f1_out;
    assign or_out = e2_out | f2_out;

    assign u = ~(xor_out | or_out);
endmodule