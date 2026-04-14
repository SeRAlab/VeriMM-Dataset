module LU_Decomposition (
    input [3:0] matrix,        // 4-bit input for 2x2 matrix
    output reg [3:0] L,        // 4-bit output for Lower triangular matrix
    output reg [3:0] U         // 4-bit output for Upper triangular matrix
);
    always @(*) begin
        // Assuming input matrix:
        // | a b |
        // | c d |
        // The LU decomposition will yield:
        // L = | 1 0 |
        //      | c/a 1 |
        // U = | a b |
        //      | 0 (d - c*(b/a)) |
        
        // First row of U
        U[3:2] = matrix[3:2]; // a, b
        // Second row of U
        U[1:0] = 2'b00; // The second row will have a 0 in the first column
        
        // First row of L
        L[3:2] = 2'b01; // 1, 0
        // Second row of L
        L[1:0] = {matrix[2]/matrix[3], 1'b1}; // c/a, 1
    end
endmodule