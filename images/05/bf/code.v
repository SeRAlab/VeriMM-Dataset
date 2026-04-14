module bilinear_interpolation(
    input [7:0] A, // Top-left pixel
    input [7:0] B, // Top-right pixel
    input [7:0] C, // Bottom-left pixel
    input [7:0] D, // Bottom-right pixel
    input [7:0] x, // x coordinate (fractional part)
    input [7:0] y, // y coordinate (fractional part)
    output [7:0] out // Interpolated pixel value
);
    wire [15:0] top_interp, bottom_interp;
    
    // Interpolate between A and B
    assign top_interp = (A * (256 - x) + B * x) >> 8;
    
    // Interpolate between C and D
    assign bottom_interp = (C * (256 - x) + D * x) >> 8;
    
    // Interpolate between top_interp and bottom_interp
    assign out = (top_interp * (256 - y) + bottom_interp * y) >> 8;
endmodule