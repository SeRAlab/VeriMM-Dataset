module Q(
    input f,
    input g,
    output v
);
    assign v = (f ^ g);
endmodule

module R(
    input f,
    input g,
    output v
);
    assign v = (f ^ g);
endmodule

module top_module(
    input f,
    input g,
    output v
);
    wire q1_out, q2_out, r_out;
    wire xor_out;

    Q q1(.f(f), .g(g), .v(q1_out));
    Q q2(.f(f), .g(g), .v(q2_out));
    R r1(.f(f), .g(g), .v(r_out));

    assign xor_out = q1_out ^ r_out;
    assign v = xor_out & q2_out;
endmodule