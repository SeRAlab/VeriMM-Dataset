module R(
    input a,
    input b,
    output t
);
    assign t = a ^ b;
endmodule

module S(
    input a,
    input b,
    output t
);
    assign t = a ^ b;
endmodule

module top_module(
    input a,
    input b,
    output t
);
    wire r1_out, r2_out, s1_out, s2_out;
    wire or_out, and_out, xor_out;

    R r1(.a(a), .b(b), .t(r1_out));
    R r2(.a(a), .b(b), .t(r2_out));
    S s1(.a(a), .b(b), .t(s1_out));
    S s2(.a(a), .b(b), .t(s2_out));

    assign or_out = r1_out | s1_out;
    assign and_out = r2_out & s2_out;
    assign t = or_out ^ and_out;
endmodule