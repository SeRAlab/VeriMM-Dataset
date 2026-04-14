module gaussian_blur (
    input [7:0] p00, // Pixel (0,0)
    input [7:0] p01, // Pixel (0,1)
    input [7:0] p02, // Pixel (0,2)
    input [7:0] p10, // Pixel (1,0)
    input [7:0] p11, // Pixel (1,1)
    input [7:0] p12, // Pixel (1,2)
    input [7:0] p20, // Pixel (2,0)
    input [7:0] p21, // Pixel (2,1)
    input [7:0] p22, // Pixel (2,2)
    output reg [7:0] blurred_pixel // Output blurred pixel value
);

always @* begin
    blurred_pixel = (p00 + p01*2 + p02 + p10*2 + p11*4 + p12*2 + p20 + p21*2 + p22) / 16;
end

endmodule