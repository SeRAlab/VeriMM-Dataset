module unsigned_comparator (
    input [3:0] A,
    input [3:0] B,
    output EQ,
    output GT,
    output LT
);

    assign EQ = (A == B);
    assign GT = (A > B);
    assign LT = (A < B);

endmodule