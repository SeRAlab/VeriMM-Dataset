module top_module(
    input A,
    input B,
    input C,
    input D,
    output X
);wire AB, CD, ABCD;

    assign AB = A | B;
    assign CD = C | D;
    assign ABCD = AB | CD;
    assign X = ABCD;

endmodule