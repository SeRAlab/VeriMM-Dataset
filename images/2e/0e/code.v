module nearest_neighbor_interpolation(
    input [1:0] x, // x coordinate (0 or 1)
    input [1:0] y, // y coordinate (0 or 1)
    output [7:0] pixel_value
);
    reg [7:0] image [0:1][0:1]; // 2x2 image

    initial begin
        // Initialize the image with some values
        image[0][0] = 8'hFF; // Pixel (0, 0)
        image[0][1] = 8'hAA; // Pixel (0, 1)
        image[1][0] = 8'h55; // Pixel (1, 0)
        image[1][1] = 8'h00; // Pixel (1, 1)
    end

    assign pixel_value = image[x][y]; // Output nearest pixel value based on (x, y)

endmodule