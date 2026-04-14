module matrix_inverse (
    input [31:0] a11, a12, a21, a22,  // Elements of the 2x2 matrix
    output reg [31:0] b11, b12, b21, b22 // Elements of the inverted matrix
);
    wire [31:0] det;  // Determinant of the matrix
    assign det = a11 * a22 - a12 * a21;  // Determinant calculation

    always @(*) begin
        if (det == 0) begin
            // Matrix is not invertible
            b11 = 32'b0;
            b12 = 32'b0;
            b21 = 32'b0;
            b22 = 32'b0;
        end else begin
            // Matrix is invertible
            b11 = a22 / det; 
            b12 = -a12 / det;
            b21 = -a21 / det;
            b22 = a11 / det;
        end
    end
endmodule