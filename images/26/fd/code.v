module matrix_inverse (
    input [7:0] a,
    input [7:0] b,
    input [7:0] c,
    input [7:0] d,
    output [7:0] inv_a,
    output [7:0] inv_b,
    output [7:0] inv_c,
    output [7:0] inv_d
);
    wire signed [15:0] det;
    wire signed [15:0] inv_det;

    assign det = a * d - b * c;
    assign inv_det = 1 / det; // Inverse of determinant

    assign inv_a = inv_det * d; // (1/det) * d
    assign inv_b = -inv_det * b; // -(1/det) * b
    assign inv_c = -inv_det * c; // -(1/det) * c
    assign inv_d = inv_det * a; // (1/det) * a
endmodule