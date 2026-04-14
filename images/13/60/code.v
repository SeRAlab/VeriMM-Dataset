module bilinear_interpolation (
    input [7:0] Q11, // pixel value at (x1, y1)
    input [7:0] Q12, // pixel value at (x1, y2)
    input [7:0] Q21, // pixel value at (x2, y1)
    input [7:0] Q22, // pixel value at (x2, y2)
    input [7:0] x,   // x fractional part (0-255)
    input [7:0] y,   // y fractional part (0-255)
    output [15:0] P   // interpolated pixel value
);
    wire [15:0] R1, R2;

    assign R1 = Q11 * (256 - x) + Q21 * x; // Interpolation in x-direction
    assign R2 = Q12 * (256 - x) + Q22 * x; // Interpolation in x-direction

    assign P = R1 * (256 - y) + R2 * y;     // Final interpolation in y-direction
endmodule