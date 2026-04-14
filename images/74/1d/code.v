module top_module(
    out,
    a,
    b,
    c,
    d,
    e
);output out;
    input a;
    input [1:0] b;
    input [2:0] c;
    input [3:0] d;
    input [4:0] e;

    wire [4:0] complement;
    wire [4:0] xor_inputs;
    wire all_complement;

    assign complement = {~a, ~b, ~c, ~d, ~e};
    assign xor_inputs = {a, b[0], b[1], c[0], c[1], c[2], d[0], d[1], d[2], d[3], e[0], e[1], e[2], e[3], e[4]};
    assign all_complement = &complement;

    assign out = all_complement ? 0 : (|complement) ? 1 : ^xor_inputs;

endmodule