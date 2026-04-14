module dct_4point (
    input signed [7:0] x0, x1, x2, x3,
    output signed [9:0] y0, y1, y2, y3
);
    // DCT constants
    parameter c0 = 8'hE0;  // cos(0 * pi / 8) * 128
    parameter c1 = 8'hED;  // cos(1 * pi / 8) * 128
    parameter c2 = 8'hE0;  // cos(2 * pi / 8) * 128
    parameter c3 = 8'hED;  // cos(3 * pi / 8) * 128
    
    assign y0 = (x0 + x1 + x2 + x3) * c0 >> 7;
    assign y1 = (x0 + x2) * c1 >> 7 + (x1 + x3) * c3 >> 7;
    assign y2 = (x0 + x2) * c2 >> 7 - (x1 + x3) * c3 >> 7;
    assign y3 = (x0 - x1 + x2 - x3) * c1 >> 7;
endmodule