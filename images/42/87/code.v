module K(
    input x,
    input y,
    output m
);
    assign m = x | ~y;
endmodule

module L(
    input x,
    input y,
    output m
);
    assign m = x | ~y;
endmodule

module top_module(
    input x,
    input y,
    output m
);
    wire k1_out, k2_out, l1_out, l2_out;
    wire xor_out, and_out;

    K k1(.x(x), .y(y), .m(k1_out));
    K k2(.x(x), .y(y), .m(k2_out));
    L l1(.x(x), .y(y), .m(l1_out));
    L l2(.x(x), .y(y), .m(l2_out));

    assign xor_out = k1_out ^ l1_out;
    assign and_out = k2_out & l2_out;

    assign m = xor_out | and_out;
endmodule