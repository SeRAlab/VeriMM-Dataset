module matrix_inverse (
    input [15:0] matrix, // 2x2 matrix represented as a single 16-bit input
    output reg [15:0] inverse, // 2x2 inverse matrix output
    output reg valid // output valid flag
);
    wire signed [15:0] a, b, c, d; // elements of the matrix
    wire signed [31:0] det; // determinant of the matrix

    assign {a, b, c, d} = matrix; // unpack matrix elements
    assign det = a * d - b * c; // determinant calculation

    always @(*) begin
        if (det != 0) begin
            inverse = {d / det, -b / det, -c / det, a / det}; // calculate inverse
            valid = 1;
        end else begin
            inverse = 16'h0000; // if determinant is zero, output zero matrix
            valid = 0;
        end
    end
endmodule