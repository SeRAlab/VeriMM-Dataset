module G(
    input x,
    input y,
    output z
);
    assign z = x | y;
endmodule

module H(
    input x,
    input y,
    output z
);
    assign z = x | y;
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire g1_out, g2_out, h1_out, h2_out;
    wire or_out, and_out;

    G g1(.x(x), .y(y), .z(g1_out));
    G g2(.x(x), .y(y), .z(g2_out));
    H h1(.x(x), .y(y), .z(h1_out));
    H h2(.x(x), .y(y), .z(h2_out));

    assign or_out = g1_out | h1_out;
    assign and_out = g2_out & h2_out;

    assign z = or_out ^ and_out;
endmodule