module F(
    input a,
    input b,
    output z
);
    assign z = (a | b);
endmodule

module I(
    input a,
    input b,
    output z
);
    assign z = ~(a & a);
endmodule

module top_module(
    input a,
    input b,
    output z
);
    wire f1_out, f2_out, i1_out, i2_out;
    wire and_out, xor_out;

    F f1(.a(a), .b(b), .z(f1_out));
    F f2(.a(a), .b(b), .z(f2_out));
    I i1(.a(a), .b(b), .z(i1_out));
    I i2(.a(a), .b(b), .z(i2_out));

    assign and_out = f1_out & i1_out;
    assign xor_out = f2_out ^ i2_out;

    assign z = and_out | xor_out;
endmodule