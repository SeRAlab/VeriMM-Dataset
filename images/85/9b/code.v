module X(
    input a,
    input b,
    output w
);
    assign w = a ^ b;
endmodule

module Y(
    input a,
    input b,
    output w
);
    assign w = a ^ b;
endmodule

module top_module(
    input a,
    input b,
    output w
);
    wire x1_out, x2_out, y1_out, y2_out;
    wire or_out, and_out;

    X x1(.a(a), .b(b), .w(x1_out));
    X x2(.a(a), .b(b), .w(x2_out));
    Y y1(.a(a), .b(b), .w(y1_out));
    Y y2(.a(a), .b(b), .w(y2_out));

    assign or_out = x1_out | y1_out;
    assign and_out = x2_out & y2_out;

    assign w = ~(or_out | and_out);
endmodule