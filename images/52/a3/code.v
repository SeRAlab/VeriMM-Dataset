module I(
    input x,
    input y,
    output z
);
    assign z = x | y;
endmodule

module J(
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
    wire i1_out, i2_out, j1_out, j2_out;
    wire nor_out, xor_out;

    I i1(.x(x), .y(y), .z(i1_out));
    I i2(.x(x), .y(y), .z(i2_out));
    J j1(.x(x), .y(y), .z(j1_out));
    J j2(.x(x), .y(y), .z(j2_out));

    assign nor_out = ~(i1_out | j1_out);
    assign xor_out = i2_out ^ j2_out;

    assign z = nor_out & xor_out;
endmodule