module P(
    input a,
    input b,
    output t
);
    assign t = a ~^ b;
endmodule

module Q(
    input a,
    input b,
    output t
);
    assign t = a ~^ b;
endmodule

module top_module(
    input a,
    input b,
    output t
);
    wire p1_out, p2_out, q1_out, q2_out;
    wire and_out, nand_out;

    P p1(.a(a), .b(b), .t(p1_out));
    P p2(.a(a), .b(b), .t(p2_out));
    Q q1(.a(a), .b(b), .t(q1_out));
    Q q2(.a(a), .b(b), .t(q2_out));

    assign and_out = p1_out & q1_out;
    assign nand_out = ~(p2_out & q2_out);

    assign t = and_out | nand_out;
endmodule