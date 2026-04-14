module V(
    input x,
    input y,
    output z
);
    assign z = (x | ~y);
endmodule

module W(
    input x,
    input y,
    output z
);
    assign z = (x | ~y);
endmodule

module top_module(
    input x,
    input y,
    output z
);
    wire v1_out, v2_out, w1_out, w2_out;
    wire and_out, xor_out;

    V v1(.x(x), .y(y), .z(v1_out));
    V v2(.x(x), .y(y), .z(v2_out));
    W w1(.x(x), .y(y), .z(w1_out));
    W w2(.x(x), .y(y), .z(w2_out));

    assign and_out = v1_out & w1_out;
    assign xor_out = v2_out ^ w2_out;

    assign z = and_out | xor_out;
endmodule