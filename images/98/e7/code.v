module M(
    input x,
    input y,
    output n
);
    assign n = ~(x | y);
endmodule

module N(
    input x,
    input y,
    output n
);
    assign n = ~(x | y);
endmodule

module top_module(
    input x,
    input y,
    output n
);
    wire m1_out, m2_out, n1_out, n2_out;
    wire nor_out, xor_out;

    M m1(.x(x), .y(y), .n(m1_out));
    M m2(.x(x), .y(y), .n(m2_out));
    N n1(.x(x), .y(y), .n(n1_out));
    N n2(.x(x), .y(y), .n(n2_out));

    assign nor_out = ~(m1_out | n1_out);
    assign xor_out = m2_out ^ n2_out;

    assign n = nor_out & xor_out;
endmodule