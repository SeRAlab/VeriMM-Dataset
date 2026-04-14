module X(
    input a,
    input b,
    output z
);
    assign z = a & b;
endmodule

module Y(
    input a,
    input b,
    output z
);
    assign z = a & b;
endmodule

module top_module(
    input a,
    input b,
    output z
);
    wire x1_out, x2_out, y1_out, y2_out;
    wire or_out, and_out, xor_out;

    X x1(.a(a), .b(b), .z(x1_out));
    X x2(.a(a), .b(b), .z(x2_out));
    Y y1(.a(a), .b(b), .z(y1_out));
    Y y2(.a(a), .b(b), .z(y2_out));

    assign or_out = x1_out | y1_out;
    assign and_out = x2_out & y2_out;
    assign z = or_out ^ and_out;
endmodule