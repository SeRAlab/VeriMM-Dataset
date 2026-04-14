module D(
    input a,
    input b,
    input c,
    output v
);
    assign v = a | (b & ~c);
endmodule

module E(
    input a,
    input b,
    input c,
    output v
);
    assign v = a | (b & ~c);
endmodule

module top_module(
    input a,
    input b,
    input c,
    output v
);
    wire d1_out, d2_out, e1_out, e2_out;
    wire or_out, and_out, xor_out;

    D d1(.a(a), .b(b), .c(c), .v(d1_out));
    D d2(.a(a), .b(b), .c(c), .v(d2_out));
    E e1(.a(a), .b(b), .c(c), .v(e1_out));
    E e2(.a(a), .b(b), .c(c), .v(e2_out));

    assign or_out = d1_out | e1_out;
    assign and_out = d2_out & e2_out;
    assign v = or_out ^ and_out;
endmodule