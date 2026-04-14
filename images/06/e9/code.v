module matrix_mult (
    input [7:0] a11, a12, a21, a22, // 8-bit inputs for elements of Matrix A
    input [7:0] b11, b12, b21, b22, // 8-bit inputs for elements of Matrix B
    output reg [15:0] c11, c12, c21, c22 // 16-bit outputs for elements of Matrix C
);
    always @(*) begin
        c11 = (a11 * b11) + (a12 * b21);
        c12 = (a11 * b12) + (a12 * b22);
        c21 = (a21 * b11) + (a22 * b21);
        c22 = (a21 * b12) + (a22 * b22);
    end
endmodule