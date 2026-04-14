module matrix_mult (
    input [15:0] A,  // 2x2 matrix A, flattened (A[3:0], A[7:4], A[11:8], A[15:12])
    input [15:0] B,  // 2x2 matrix B, flattened (B[3:0], B[7:4], B[11:8], B[15:12])
    output [15:0] C  // 2x2 matrix C, flattened (C[3:0], C[7:4], C[11:8], C[15:12])
);
    assign C[3:0]   = A[3:0] * B[3:0] + A[7:4] * B[11:8]; // C[0][0]
    assign C[7:4]   = A[3:0] * B[7:4] + A[7:4] * B[15:12]; // C[0][1]
    assign C[11:8]  = A[11:8] * B[3:0] + A[15:12] * B[11:8]; // C[1][0]
    assign C[15:12] = A[11:8] * B[7:4] + A[15:12] * B[15:12]; // C[1][1]
endmodule