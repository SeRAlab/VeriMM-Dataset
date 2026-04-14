module C(
    input x,
    input y,
    output t
);
    assign t = x & y;
endmodule

module D(
    input x,
    input y,
    output t
);
    assign t = x & y;
endmodule

module top_module(
    input x,
    input y,
    output t
);
    wire c1_out, c2_out, d1_out, d2_out;
    wire nor_out, nand_out;

    C c1(.x(x), .y(y), .t(c1_out));
    C c2(.x(x), .y(y), .t(c2_out));
    D d1(.x(x), .y(y), .t(d1_out));
    D d2(.x(x), .y(y), .t(d2_out));

    assign nor_out = ~(c1_out | d1_out);
    assign nand_out = ~(c2_out & d2_out);

    assign t = nor_out ^ nand_out;
endmodule