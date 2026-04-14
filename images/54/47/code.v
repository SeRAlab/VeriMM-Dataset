module E(
    input a,
    input b,
    output z
);
    assign z = a ^ b;
endmodule

module F(
    input a,
    input b,
    output z
);
    assign z = a ^ b;
endmodule

module top_module(
    input a,
    input b,
    output z
);
    wire e1_out, e2_out, f1_out, f2_out;
    wire or_out, nor_out;

    E e1(.a(a), .b(b), .z(e1_out));
    E e2(.a(a), .b(b), .z(e2_out));
    F f1(.a(a), .b(b), .z(f1_out));
    F f2(.a(a), .b(b), .z(f2_out));

    assign or_out = e1_out | f1_out;
    assign nor_out = ~(e2_out | f2_out);

    assign z = or_out & nor_out;
endmodule