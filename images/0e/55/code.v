module gaussian_blur (
    input [8:0] pixel0, // pixel 0
    input [8:0] pixel1, // pixel 1
    input [8:0] pixel2, // pixel 2
    input [8:0] pixel3, // pixel 3
    input [8:0] pixel4, // pixel 4
    input [8:0] pixel5, // pixel 5
    input [8:0] pixel6, // pixel 6
    input [8:0] pixel7, // pixel 7
    input [8:0] pixel8, // pixel 8
    output reg [8:0] blurred_pixel // output blurred pixel
);
    
    always @(*) begin
        blurred_pixel = (pixel0 + pixel1 + pixel2 + pixel3 + pixel4 + pixel5 + pixel6 + pixel7 + pixel8) / 9;
    end
endmodule