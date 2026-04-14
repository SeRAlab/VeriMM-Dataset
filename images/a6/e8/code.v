module O(
    input x,
    input y,
    output z
);
    assign z = ~(x | y);
endmodule

module P(
    input x,
    input y,
    output z
);
    assign z = ~(x | y);
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire o1_out, o2_out, p1_out, p2_out;
    wire and_out, nor_out;

    O o1(.x(x), .y(y), .z(o1_out));
    O o2(.x(x), .y(y), .z(o2_out));
    P p1(.x(x), .y(y), .z(p1_out));
    P p2(.x(x), .y(y), .z(p2_out));

    assign and_out = o1_out & p1_out;
    assign nor_out = ~(o2_out | p2_out);

    assign z = and_out ^ nor_out;
endmodule