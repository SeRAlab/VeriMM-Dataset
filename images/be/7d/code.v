module top_module(
    input A,
    input B,
    input C,
    input D_N,
    output X
);assign X = ~(A & B & C & D_N);

endmodule