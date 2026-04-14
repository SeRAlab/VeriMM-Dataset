module X(
    input p,
    input q,
    output z
);
    assign z = (p ^ ~q);
endmodule

module Y(
    input p,
    input q,
    output z
);
    assign z = (p ^ ~q);
endmodule

module top_module(
    input p,
    input q,
    output z
);
    wire x1_out, x2_out, y1_out, y2_out;
    wire or_out, and_out;

    X x1(.p(p), .q(q), .z(x1_out));
    X x2(.p(p), .q(q), .z(x2_out));
    Y y1(.p(p), .q(q), .z(y1_out));
    Y y2(.p(p), .q(q), .z(y2_out));

    assign or_out = x1_out | y1_out;
    assign and_out = x2_out & y2_out;

    assign z = or_out ^ and_out;
endmodule