module C(
    input x,
    input y,
    output r
);
    assign r = (x ^ y);
endmodule

module D(
    input x,
    input y,
    output r
);
    assign r = (x ^ y);
endmodule

module top_module(
    input x,
    input y,
    output r
);
    wire c_out, d1_out, d2_out;
    wire nor_out;

    C c1(.x(x), .y(y), .r(c_out));
    D d1(.x(x), .y(y), .r(d1_out));
    D d2(.x(x), .y(y), .r(d2_out));

    assign nor_out = ~(d1_out | c_out);
    assign r = nor_out & d2_out;
endmodule