module comparator_4bit(
    input [3:0] A,
    input [3:0] B,
    output EQ,
    output GT
    );

    assign EQ = (A == B);
    assign GT = (A > B);

endmodule