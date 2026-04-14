module matrix_inverse(
    input [31:0] a11, a12, // first row of the matrix
    input [31:0] a21, a22, // second row of the matrix
    output reg [31:0] b11, b12, // first row of the inverse
    output reg [31:0] b21, b22, // second row of the inverse
    output reg valid // indicates if the inverse is valid
);
    wire signed [31:0] det;

    // Calculate determinant
    assign det = a11 * a22 - a12 * a21;

    always @(*) begin
        if (det != 0) begin
            b11 = a22 / det;
            b12 = -a12 / det;
            b21 = -a21 / det;
            b22 = a11 / det;
            valid = 1;
        end else begin
            b11 = 32'hx;
            b12 = 32'hx;
            b21 = 32'hx;
            b22 = 32'hx;
            valid = 0; // singular matrix, no inverse
        end
    end
endmodule