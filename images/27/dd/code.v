module bilinear_interpolation(
    input [7:0] Q11, Q12, Q21, Q22,  // 8-bit pixel values
    input [7:0] x, y,                // 8-bit fractional parts (0-255)
    output reg [15:0] P               // 16-bit output pixel value
);
    always @* begin
        P = ( ( (255 - x) * (255 - y) * Q11 +
                  (255 - x) * y * Q12 +
                  x * (255 - y) * Q21 +
                  x * y * Q22 ) >> 16 ); // shifting to normalize output
    end
endmodule