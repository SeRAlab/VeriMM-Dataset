module C(
    input x,
    input y,
    output z
);
    assign z = x & ~y;
endmodule

module D(
    input x,
    input y,
    output z
);
    assign z = (~x & ~y) | (x & ~y);
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire c1_out, c2_out, d1_out, d2_out;
    wire nand_out, nor_out;

    C c1(.x(x), .y(y), .z(c1_out));
    C c2(.x(x), .y(y), .z(c2_out));
    D d1(.x(x), .y(y), .z(d1_out));
    D d2(.x(x), .y(y), .z(d2_out));

    assign nand_out = ~(c1_out & d1_out);
    assign nor_out = ~(c2_out | d2_out);

    assign z = nand_out ^ nor_out;
endmodule