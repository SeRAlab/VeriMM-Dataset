module matrix_factorization #(parameter N = 3) (
    input [N*N-1:0] A, // Flattened input matrix A
    input [N*N-1:0] B, // Flattened input matrix B
    output reg [N*N-1:0] C // Flattened output matrix C
);
    integer i, j, k;
    reg [15:0] sum; // Temporary variable to hold the sum for each element in C

    always @(*) begin
        // Initialize output matrix C to zero
        C = 0;
        // Matrix multiplication
        for (i = 0; i < N; i = i + 1) begin
            for (j = 0; j < N; j = j + 1) begin
                sum = 0;
                for (k = 0; k < N; k = k + 1) begin
                    sum = sum + A[i*N + k] * B[k*N + j];
                end
                C[i*N + j] = sum;
            end
        end
    end
endmodule