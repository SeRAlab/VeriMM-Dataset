module magnitude_comparator (
    input [3:0] A,
    input [3:0] B,
    output reg greater_or_equal
);

    // Compare the MSB of A and B
    assign greater_or_equal = (A[3] & ~B[3]) | ((A[3] ^ B[3]) & ~(A[2:0] ^ B[2:0]));

endmodule