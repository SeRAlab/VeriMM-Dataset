module top_module(
    input A1,
    input A2,
    input B1,
    input B2,
    output X
);assign X = (A1 & B1) | ~(A2 | B2);

endmodule