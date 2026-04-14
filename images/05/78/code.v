module matrix_multiply (
    input [3:0] A, // Matrix A
    input [3:0] B, // Matrix B
    output [7:0] C // Resulting Matrix C
);
    assign C[0] = A[0] * B[0] + A[1] * B[2]; // C[0][0]
    assign C[1] = A[0] * B[1] + A[1] * B[3]; // C[0][1]
    assign C[2] = A[2] * B[0] + A[3] * B[2]; // C[1][0]
    assign C[3] = A[2] * B[1] + A[3] * B[3]; // C[1][1]
    assign C[4] = C[0]; // Storing the first row
    assign C[5] = C[1]; // Storing the second column
    assign C[6] = C[2]; // Storing the first column
    assign C[7] = C[3]; // Storing the second row
endmodule