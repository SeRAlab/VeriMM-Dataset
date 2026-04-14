module O(
    input d,
    input e,
    output x
);
    assign x = (d | ~e);
endmodule

module P(
    input d,
    input e,
    output x
);
    assign x = (d | ~e);
endmodule

module top_module(
    input d,
    input e,
    output x
);
    wire o1_out, o2_out, o3_out, p_out;
    wire or_out, and_out;

    O o1(.d(d), .e(e), .x(o1_out));
    O o2(.d(d), .e(e), .x(o2_out));
    O o3(.d(d), .e(e), .x(o3_out));
    P p1(.d(d), .e(e), .x(p_out));

    assign or_out = o1_out | p_out;
    assign and_out = o2_out & o3_out;

    assign x = or_out ^ and_out;
endmodule