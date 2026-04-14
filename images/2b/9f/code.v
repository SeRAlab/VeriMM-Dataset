module LU_Decomposition(
    input [15:0] matrix, // 4-bit wide 2x2 matrix flattened
    output reg [15:0] L, // Lower triangular matrix
    output reg [15:0] U  // Upper triangular matrix
);
    // The matrix is represented as:
    // matrix[15:12] = a11, matrix[11:8] = a12
    // matrix[7:4] = a21, matrix[3:0] = a22

    wire [3:0] a11 = matrix[15:12];
    wire [3:0] a12 = matrix[11:8];
    wire [3:0] a21 = matrix[7:4];
    wire [3:0] a22 = matrix[3:0];

    always @(*) begin
        // Initialize L and U
        L = 16'b0;
        U = 16'b0;

        // Calculate U
        U[15:12] = a11; // u11
        U[11:8] = a12;  // u12
        U[7:4] = a21;   // u21
        U[3:0] = a22 - (a21 * a12 / a11); // u22

        // Calculate L
        L[15:12] = 4'b0001; // l11 = 1
        L[11:8] = a21 / a11; // l21
        L[7:4] = 4'b0000; // l12 = 0
        L[3:0] = 4'b0001; // l22 = 1
    end
endmodule