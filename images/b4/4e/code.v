module E(
    input a,
    input b,
    output k
);
    assign k = ~(a ^ b);
endmodule

module F(
    input a,
    input b,
    output k
);
    assign k = ~(a ^ b);
endmodule

module top_module(
    input a,
    input b,
    output k
);
    wire e1_out, e2_out, f1_out, f2_out;
    wire nor_out, xor_out;

    E e1(.a(a), .b(b), .k(e1_out));
    E e2(.a(a), .b(b), .k(e2_out));
    F f1(.a(a), .b(b), .k(f1_out));
    F f2(.a(a), .b(b), .k(f2_out));

    assign nor_out = ~(e1_out | f1_out);
    assign xor_out = e2_out ^ f2_out;

    assign k = nor_out | xor_out;
endmodule