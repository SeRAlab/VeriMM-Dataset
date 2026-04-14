module A(
    input a,
    input b,
    output w
);
    assign w = ~a | b;
endmodule

module B(
    input a,
    input b,
    output w
);
    assign w = (~a & b) | (a & ~b);
endmodule

module top_module(
    input a,
    input b,
    output w
);
    wire a1_out, a2_out, b1_out, b2_out;
    wire and_out, xor_out, or_out;

    A a1(.a(a), .b(b), .w(a1_out));
    A a2(.a(a), .b(b), .w(a2_out));
    B b1(.a(a), .b(b), .w(b1_out));
    B b2(.a(a), .b(b), .w(b2_out));

    assign and_out = a1_out & b1_out;
    assign xor_out = a2_out ^ b2_out;
    assign w = and_out | xor_out;
endmodule