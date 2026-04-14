module bilinear_interpolation (
    input [7:0] P11, // Pixel value at (x1, y1)
    input [7:0] P12, // Pixel value at (x1, y2)
    input [7:0] P21, // Pixel value at (x2, y1)
    input [7:0] P22, // Pixel value at (x2, y2)
    input [7:0] fx,   // Fractional part in x direction (0-255)
    input [7:0] fy,   // Fractional part in y direction (0-255)
    output reg [7:0] Pout // Interpolated pixel value
);
    wire [15:0] P1, P2, P3, P4;
    wire [15:0] top, bottom;

    // Calculating contributions from each corner
    assign P1 = P11 * (256 - fx) * (256 - fy); // (1-fx)(1-fy) * P11
    assign P2 = P12 * (256 - fx) * fy;         // (1-fx)(fy) * P12
    assign P3 = P21 * fx * (256 - fy);         // (fx)(1-fy) * P21
    assign P4 = P22 * fx * fy;                  // (fx)(fy) * P22

    // Sum all contributions
    always @(*) begin
        Pout = (P1 + P2 + P3 + P4) >> 16; // Divide by 65536 to normalize
    end
endmodule