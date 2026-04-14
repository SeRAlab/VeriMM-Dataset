module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);assign X = A | B | C | D;

endmodule