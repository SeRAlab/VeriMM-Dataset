module top_module(
    input A,
    input B,
    input S,
    output X
);assign X = S ? B : A;

endmodule