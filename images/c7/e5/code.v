module comparator (
    input [3:0] A,
    input [3:0] B,
    output EQ,
    output GT,
    output LT
);

    assign EQ = (A == B) ? 1 : 0;
    assign GT = (A > B) ? 1 : 0;
    assign LT = (A < B) ? 1 : 0;

endmodule