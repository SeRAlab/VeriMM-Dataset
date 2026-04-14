module C(
    input a,
    input b,
    output r
);
    assign r = ~(a & b);
endmodule

module D(
    input a,
    input b,
    output r
);
    assign r = ~(a & b);
endmodule

module top_module(
    input a,
    input b,
    output r
);
    wire c1_out, c2_out, d1_out, d2_out;
    wire or_out, nor_out;

    C c1(.a(a), .b(b), .r(c1_out));
    C c2(.a(a), .b(b), .r(c2_out));
    D d1(.a(a), .b(b), .r(d1_out));
    D d2(.a(a), .b(b), .r(d2_out));

    assign or_out = c1_out | d1_out;
    assign nor_out = ~(c2_out | d2_out);

    assign r = or_out ^ nor_out;
endmodule