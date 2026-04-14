module E(
    input u,
    input v,
    output t
);
    assign t = (u & v);
endmodule

module F(
    input u,
    input v,
    output t
);
    assign t = (u & v);
endmodule

module top_module(
    input u,
    input v,
    output t
);
    wire e1_out, e2_out, f_out;
    wire and_out;

    E e1(.u(u), .v(v), .t(e1_out));
    E e2(.u(u), .v(v), .t(e2_out));
    F f1(.u(u), .v(v), .t(f_out));

    assign and_out = e1_out & f_out;
    assign t = and_out | e2_out;
endmodule