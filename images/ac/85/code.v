module top_module(
    input a,
    input b,
    input c,
    output out
);wire ab, bc, abc;

    and and1 (ab, a, b);
    and and2 (bc, b, c);
    and and3 (abc, ab, c);
    assign out = abc;

endmodule