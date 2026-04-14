module top_module(
    input A,
    input B,
    input C,
    input D,
    input E,
    input F,
    input G,
    input H,
    output X
);assign X = (A & B) | (~C & D) | (E ^ F) | (~G & H);

endmodule