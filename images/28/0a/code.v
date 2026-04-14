module BilinearInterpolation (
    input [15:0] P00,   // pixel value at (0,0)
    input [15:0] P01,   // pixel value at (0,1)
    input [15:0] P10,   // pixel value at (1,0)
    input [15:0] P11,   // pixel value at (1,1)
    input [15:0] Xfrac,  // fractional x coordinate (fixed-point)
    input [15:0] Yfrac,  // fractional y coordinate (fixed-point)
    output [15:0] Pout   // interpolated pixel value
);

wire [31:0] P0, P1, P2, P3;
wire [31:0] Pout_temp1, Pout_temp2;

// Compute the contributions of each pixel
assign P0 = (P00 * (256 - Xfrac) * (256 - Yfrac)); // P00 * (1-X)(1-Y)
assign P1 = (P01 * Xfrac * (256 - Yfrac));         // P01 * (X)(1-Y)
assign P2 = (P10 * (256 - Xfrac) * Yfrac);         // P10 * (1-X)(Y)
assign P3 = (P11 * Xfrac * Yfrac);                   // P11 * (X)(Y)

// Sum contributions
assign Pout_temp1 = P0 + P1 + P2 + P3;
assign Pout = Pout_temp1 >> 16; // Divide by 256 (2^8) to get final output

endmodule