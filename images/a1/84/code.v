module R(
    input a,
    input b,
    output u
);
    assign u = a & ~b;
endmodule

module S(
    input a,
    input b,
    output u
);
    assign u = a & ~b;
endmodule

module top_module(
    input a,
    input b,
    output u
);
    wire r1_out, r2_out, s1_out, s2_out;
    wire nor_out, xor_out;

    R r1(.a(a), .b(b), .u(r1_out));
    R r2(.a(a), .b(b), .u(r2_out));
    S s1(.a(a), .b(b), .u(s1_out));
    S s2(.a(a), .b(b), .u(s2_out));

    assign nor_out = ~(r1_out | s1_out);
    assign xor_out = r2_out ^ s2_out;

    assign u = nor_out & xor_out;
endmodule