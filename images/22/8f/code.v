module matrix_mult (
    input [7:0] A, // First 2x2 matrix (A[3:0] A[7:4])
    input [7:0] B, // Second 2x2 matrix (B[3:0] B[7:4])
    output reg [7:0] C // Resultant 2x2 matrix (C[3:0] C[7:4])
);
    always @(*) begin
        C[3:0] = A[3:0] * B[3:0] + A[7:4] * B[7:4]; // C[0][0]
        C[7:4] = A[3:0] * B[7:4] + A[7:4] * B[3:0]; // C[0][1]
    end
endmodule