module top_module(
    input [1:0] A,
    input [1:0] B,
    output EQ
);wire eq1, eq2, eq3;

    // Check if A[1] == B[1]
    xor x1(eq1, A[1], B[1]);

    // Check if A[0] == B[0]
    xor x2(eq2, A[0], B[0]);

    // Check if A == B
    and a1(eq3, eq1, eq2);

    // Set output EQ to 1 if A == B, 0 otherwise
    assign EQ = eq3;

endmodule