module O(
    input x,
    input y,
    input z,
    output p
);
    assign p = x & y & z;
endmodule

module P(
    input x,
    input y,
    input z,
    output p
);
    assign p = x & y & z;
endmodule

module top_module(
    input x,
    input y,
    input z,
    output p
);
    wire o1_out, o2_out, p1_out, p2_out;
    wire nor_out, or_out;

    O o1(.x(x), .y(y), .z(z), .p(o1_out));
    O o2(.x(x), .y(y), .z(z), .p(o2_out));
    P p1(.x(x), .y(y), .z(z), .p(p1_out));
    P p2(.x(x), .y(y), .z(z), .p(p2_out));

    assign nor_out = ~(o1_out | p1_out);
    assign or_out = o2_out | p2_out;

    assign p = ~(nor_out & or_out);
endmodule