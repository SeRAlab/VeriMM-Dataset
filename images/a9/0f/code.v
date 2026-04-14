module R(
    input t,
    input u,
    output z
);
    assign z = (t & ~u);
endmodule

module S(
    input t,
    input u,
    output z
);
    assign z = (t & ~u);
endmodule

module top_module(
    input t,
    input u,
    output z
);
    wire r1_out, r2_out, s1_out, s2_out;
    wire or_out, and_out;

    R r1(.t(t), .u(u), .z(r1_out));
    R r2(.t(t), .u(u), .z(r2_out));
    S s1(.t(t), .u(u), .z(s1_out));
    S s2(.t(t), .u(u), .z(s2_out));

    assign or_out = r1_out | s1_out;
    assign and_out = r2_out & s2_out;

    assign z = or_out ^ and_out;
endmodule