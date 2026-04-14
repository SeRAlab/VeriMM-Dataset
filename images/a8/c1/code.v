module A(
    input x,
    input y,
    output w
);
    assign w = x | y;
endmodule

module B(
    input x,
    input y,
    output w
);
    assign w = x | y;
endmodule

module top_module(
    input x,
    input y,
    output w
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire and_out, or_out;

    A a1(.x(x), .y(y), .w(a1_out));
    A a2(.x(x), .y(y), .w(a2_out));
    B b1(.x(x), .y(y), .w(b1_out));
    B b2(.x(x), .y(y), .w(b2_out));

    assign and_out = a1_out & b1_out;
    assign or_out = a2_out | b2_out;

    assign w = ~(and_out & or_out);
endmodule