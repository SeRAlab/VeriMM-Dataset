module bilinear_interpolation (
    input [7:0] P00, // pixel value at (0,0)
    input [7:0] P01, // pixel value at (0,1)
    input [7:0] P10, // pixel value at (1,0)
    input [7:0] P11, // pixel value at (1,1)
    input [7:0] X_frac, // fractional x coordinate (0 to 255)
    input [7:0] Y_frac, // fractional y coordinate (0 to 255)
    output reg [7:0] P_out // output interpolated pixel value
);
    always @(*) begin
        // Use fixed point arithmetic for bilinear interpolation
        P_out = ((255 - X_frac) * (255 - Y_frac) * P00 +
                  X_frac * (255 - Y_frac) * P01 +
                  (255 - X_frac) * Y_frac * P10 +
                  X_frac * Y_frac * P11) >> 16; // Right shift to adjust for fixed point
    end
endmodule