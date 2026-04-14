module K(
    input x,
    input y,
    output z
);
    assign z = x & ~y;
endmodule

module L(
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
    wire k1_out, k2_out, l1_out, l2_out;
    wire and_out, or_out;

    K k1(.x(x), .y(y), .z(k1_out));
    K k2(.x(x), .y(y), .z(k2_out));
    L l1(.x(x), .y(y), .z(l1_out));
    L l2(.x(x), .y(y), .z(l2_out));

    assign and_out = k1_out & l1_out;
    assign or_out = k2_out | l2_out;

    assign z = and_out ^ or_out;
endmodule