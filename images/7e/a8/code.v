module M(
    input r,
    input s,
    output z
);
    assign z = (r & s);
endmodule

module N(
    input r,
    input s,
    output z
);
    assign z = (r & s);
endmodule

module top_module(
    input r,
    input s,
    output z
);
    wire m1_out, m2_out, n1_out, n2_out;
    wire xor_out, or_out;

    M m1(.r(r), .s(s), .z(m1_out));
    M m2(.r(r), .s(s), .z(m2_out));
    N n1(.r(r), .s(s), .z(n1_out));
    N n2(.r(r), .s(s), .z(n2_out));

    assign xor_out = m1_out ^ n1_out;
    assign or_out = m2_out | n2_out;

    assign z = xor_out & or_out;
endmodule