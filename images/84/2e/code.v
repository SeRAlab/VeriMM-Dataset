module T(
    input v,
    input w,
    output z
);
    assign z = ~(v & w);
endmodule

module U(
    input v,
    input w,
    output z
);
    assign z = ~(v & w);
endmodule

module top_module(
    input v,
    input w,
    output z
);
    wire t1_out, t2_out, u1_out, u2_out;
    wire and_out, or_out;

    T t1(.v(v), .w(w), .z(t1_out));
    T t2(.v(v), .w(w), .z(t2_out));
    U u1(.v(v), .w(w), .z(u1_out));
    U u2(.v(v), .w(w), .z(u2_out));

    assign and_out = t1_out & u1_out;
    assign or_out = t2_out | u2_out;

    assign z = and_out ^ or_out;
endmodule