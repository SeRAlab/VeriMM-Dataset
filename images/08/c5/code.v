module matrix_multiplier (
    input [7:0] A, // 2x2 Matrix A: A[7:4] A[3:0]
    input [7:0] B, // 2x2 Matrix B: B[7:4] B[3:0]
    output reg [7:0] C // 2x2 Matrix C: C[7:4] C[3:0]
);
    always @(*) begin
        C[7:4] = (A[7:4] * B[7:4]) + (A[3:0] * B[3:0]); // C[0][0]
        C[3:0] = (A[7:4] * B[3:0]) + (A[3:0] * B[7:4]); // C[0][1]
    end
endmodule