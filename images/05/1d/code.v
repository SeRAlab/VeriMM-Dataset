module GrayscaleConverter(
    input [4:0] color_in,
    output [4:0] gray_out
);
    wire [2:0] red, green, blue;
    assign red = color_in[4:3];   // 2 bits for red
    assign green = color_in[2:1]; // 2 bits for green
    assign blue = color_in[0:0];  // 1 bit for blue

    // Calculate grayscale by taking the average of red, green, and blue
    assign gray_out = (red + green + blue) / 3;
endmodule