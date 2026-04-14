module matrix_inverse (
    input wire [15:0] a, // 2x2 matrix represented as a single 16-bit input
    output wire [15:0] inv // Inverse matrix represented as a single 16-bit output
);
    wire [15:0] det; // Determinant
    assign det = a[0]*a[3] - a[1]*a[2]; // det = a11*a22 - a12*a21
    assign inv[0] = a[3] / det; // inv11
    assign inv[1] = -a[1] / det; // inv12
    assign inv[2] = -a[2] / det; // inv21
    assign inv[3] = a[0] / det; // inv22
endmodule