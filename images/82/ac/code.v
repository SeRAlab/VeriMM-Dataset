module Q(
    input x,
    input y,
    output z
);
    assign z = x & y | ~x;
endmodule

module R(
    input x,
    input y,
    output z
);
    assign z = x & ~y;
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire q1_out, q2_out, r1_out, r2_out;
    wire or_out, and_out;

    Q q1(.x(x), .y(y), .z(q1_out));
    Q q2(.x(x), .y(y), .z(q2_out));
    R r1(.x(x), .y(y), .z(r1_out));
    R r2(.x(x), .y(y), .z(r2_out));

    assign or_out = q1_out | r1_out;
    assign and_out = q2_out & r2_out;

    assign z = or_out ^ and_out;
endmodule