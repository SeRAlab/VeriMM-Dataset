module matrix_multiplier (
    input [15:0] A, // 2x2 matrix A represented as a 16-bit input
    input [15:0] B, // 2x2 matrix B represented as a 16-bit input
    output [15:0] C // 2x2 result matrix C represented as a 16-bit output
);
    // Intermediate values for multiplication
    wire [7:0] C00, C01, C10, C11;

    // Matrix multiplication calculations
    assign C00 = A[15:12] * B[15:12] + A[14:12] * B[11:8]; // C[0][0]
    assign C01 = A[15:12] * B[11:8] + A[14:12] * B[7:4];  // C[0][1]
    assign C10 = A[11:8] * B[15:12] + A[10:8] * B[11:8];  // C[1][0]
    assign C11 = A[11:8] * B[11:8] + A[10:8] * B[7:4];   // C[1][1]

    // Assigning the result to output
    assign C = {C00, C01, C10, C11};
endmodule