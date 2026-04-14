module bilinear_interpolation (
    input [7:0] A,  // Top-left pixel
    input [7:0] B,  // Top-right pixel
    input [7:0] C,  // Bottom-left pixel
    input [7:0] D,  // Bottom-right pixel
    input [7:0] x_frac,  // X fractional part (0-255)
    input [7:0] y_frac,  // Y fractional part (0-255)
    output [7:0] interpolated_pixel  // Interpolated pixel output
);
    wire [15:0] top_interp, bottom_interp;
    
    assign top_interp = (A * (255 - x_frac) + B * x_frac) >> 8;  // Interpolate top row
    assign bottom_interp = (C * (255 - x_frac) + D * x_frac) >> 8;  // Interpolate bottom row
    assign interpolated_pixel = (top_interp * (255 - y_frac) + bottom_interp * y_frac) >> 8;  // Final interpolation
    
endmodule