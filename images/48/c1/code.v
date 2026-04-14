module A(
    input m,
    input n,
    output w
);
    assign w = (m | n);
endmodule

module B(
    input m,
    input n,
    output w
);
    assign w = (m | n);
endmodule

module top_module(
    input m,
    input n,
    output w
);
    wire a1_out, a2_out, a3_out, b_out;
    wire nor_out, and_out;

    A a1(.m(m), .n(n), .w(a1_out));
    A a2(.m(m), .n(n), .w(a2_out));
    A a3(.m(m), .n(n), .w(a3_out));
    B b1(.m(m), .n(n), .w(b_out));

    assign nor_out = ~(a1_out | b_out);
    assign and_out = a2_out & a3_out;

    assign w = nor_out ^ and_out;
endmodule