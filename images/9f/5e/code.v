module K(
    input w,
    input x,
    output u
);
    assign u = (w & ~x);
endmodule

module L(
    input w,
    input x,
    output u
);
    assign u = (w & ~x);
endmodule

module top_module(
    input w,
    input x,
    output u
);
    wire k1_out, k2_out, k3_out, l1_out, l2_out;
    wire or_out, and_out;

    K k1(.w(w), .x(x), .u(k1_out));
    K k2(.w(w), .x(x), .u(k2_out));
    K k3(.w(w), .x(x), .u(k3_out));
    L l1(.w(w), .x(x), .u(l1_out));
    L l2(.w(w), .x(x), .u(l2_out));

    assign or_out = k1_out | l1_out;
    assign and_out = k2_out & k3_out;

    assign u = or_out ^ and_out;
endmodule