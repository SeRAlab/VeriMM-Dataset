module G(
    input x,
    input y,
    output v
);
    assign v = ~(x & y);
endmodule

module H(
    input x,
    input y,
    output v
);
    assign v = ~(x & y);
endmodule

module top_module(
    input x,
    input y,
    output v
);
    wire g1_out, g2_out, h1_out, h2_out;
    wire and_out, xor_out;

    G g1(.x(x), .y(y), .v(g1_out));
    G g2(.x(x), .y(y), .v(g2_out));
    H h1(.x(x), .y(y), .v(h1_out));
    H h2(.x(x), .y(y), .v(h2_out));

    assign and_out = g1_out & h1_out;
    assign xor_out = g2_out ^ h2_out;

    assign v = ~(and_out | xor_out);
endmodule