module bilinear_interpolation (
    input [7:0] P00, P01, P10, P11,
    input [15:0] x, y, // Fixed-point (8.8)
    output [15:0] Pxy // Interpolated result (16-bit)
);
    wire [15:0] R1, R2;
    
    // Calculate R1 = P00 * (1 - x) + P01 * x
    assign R1 = (P00 * (256 - x) + P01 * x) >> 8;
    
    // Calculate R2 = P10 * (1 - x) + P11 * x
    assign R2 = (P10 * (256 - x) + P11 * x) >> 8;
    
    // Calculate Pxy = R1 * (1 - y) + R2 * y
    assign Pxy = (R1 * (256 - y) + R2 * y) >> 8;
    
endmodule