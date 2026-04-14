module bilinear_interpolation(
    input [7:0] P00, // Top-left pixel
    input [7:0] P01, // Top-right pixel
    input [7:0] P10, // Bottom-left pixel
    input [7:0] P11, // Bottom-right pixel
    input [7:0] u,   // Horizontal fractional coordinate
    input [7:0] v,   // Vertical fractional coordinate
    output reg [15:0] P_out // Output pixel value
);
    always @(*) begin
        // Bilinear interpolation formula
        P_out = (P00 * (256 - u) * (256 - v) +
                  P01 * u * (256 - v) +
                  P10 * (256 - u) * v +
                  P11 * u * v) >> 16; // Right shift to scale back
    end
endmodule