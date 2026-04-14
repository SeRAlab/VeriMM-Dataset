module qr_decomposition (
    input [3:0] matrix, // 2x2 matrix as a 4-bit input (a, b, c, d)
    output reg [3:0] Q, // orthogonal matrix Q
    output reg [3:0] R  // upper triangular matrix R
);
    wire [1:0] a, b, c, d;
    assign a = matrix[3:2]; // First row, first element
    assign b = matrix[1:0]; // First row, second element
    assign c = matrix[3:2]; // Second row, first element
    assign d = matrix[1:0]; // Second row, second element

    always @(*) begin
        // QR decomposition using Gram-Schmidt process
        Q[3:2] = a; // First column of Q
        Q[1:0] = b; // Second column of Q

        // Calculate R
        R[3:2] = {a[1], 1'b0}; // R11
        R[1:0] = {b[1], d[1]}; // R21, R22
    end
endmodule