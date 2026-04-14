module top_module(
    X,
    A1,
    A2,
    B1,
    C1
);output X;
    input A1, A2, B1, C1;

    wire and_out;
    wire or_out;

    and #(1) and_gate (and_out, A1, A2);
    or  #(3) or_gate  (or_out,  C1, B1, and_out);
    buf #(1) buf_gate (X,      or_out);

endmodule