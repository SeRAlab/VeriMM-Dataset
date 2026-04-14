module comparator (
    input [7:0] A,
    input [7:0] B,
    output EQ,
    output GT
);

    assign EQ = (A == B);
    assign GT = (A > B);

endmodule