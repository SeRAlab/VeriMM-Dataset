module matrix_multiply (
    input [15:0] A, // 4x4 matrix A
    input [15:0] B, // 4x4 matrix B
    output [15:0] C  // 4x4 matrix C
);
    reg [15:0] C_reg;
    integer i, j, k;
    
    always @(*) begin
        C_reg = 0; // initialize C to zero
        for (i = 0; i < 4; i = i + 1) begin
            for (j = 0; j < 4; j = j + 1) begin
                for (k = 0; k < 4; k = k + 1) begin
                    C_reg[i * 4 + j] = C_reg[i * 4 + j] + (A[i * 4 + k] * B[k * 4 + j]);
                end
            end
        end
    end

    assign C = C_reg;
endmodule