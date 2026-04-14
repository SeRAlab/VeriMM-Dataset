module matrix_inverse (
    input [15:0] matrix_in,  // 4 bits for each of the 2x2 matrix
    output reg [15:0] matrix_out // 4 bits for each of the 2x2 inverted matrix
);

    wire [15:0] A;
    wire [15:0] det; // determinant

    assign A = matrix_in; // 4 bits for each element of the matrix
    assign det = A[0]*A[3] - A[1]*A[2]; // determinant of 2x2 matrix

    always @(*) begin
        if (det != 0) begin
            // Inverse calculation: 1/det * adjoint
            matrix_out = {A[3] / det, -A[1] / det, -A[2] / det, A[0] / det};
        end else begin
            matrix_out = 16'hFFFF; // Indicate error on singular matrix
        end
    end
endmodule