module bilinear_interpolation (
    input [7:0] A, // Top-left pixel
    input [7:0] B, // Top-right pixel
    input [7:0] C, // Bottom-left pixel
    input [7:0] D, // Bottom-right pixel
    input [7:0] u, // Horizontal interpolation factor
    input [7:0] v, // Vertical interpolation factor
    output [7:0] pixel_out // Interpolated pixel value
);
    wire [15:0] top, bottom;
    wire [15:0] A_weighted, B_weighted, C_weighted, D_weighted;

    // Bilinear interpolation formula
    assign A_weighted = A * (256 - u) * (256 - v);
    assign B_weighted = B * u * (256 - v);
    assign C_weighted = C * (256 - u) * v;
    assign D_weighted = D * u * v;

    assign top = A_weighted + B_weighted;
    assign bottom = C_weighted + D_weighted;

    assign pixel_out = (top + bottom) >> 16; // Right shift to scale down to 8 bits

endmodule