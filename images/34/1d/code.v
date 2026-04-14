module sobel_edge_detection(
    input [8*9-1:0] pixels, // 3x3 pixel grayscale image
    output reg [7:0] gradient_magnitude // Output gradient magnitude
);
    integer i, j;
    reg signed [15:0] Gx, Gy; // Gradient components
    reg [7:0] pixel[0:2][0:2]; // 3x3 pixel array

    always @* begin
        // Unpack the input pixels into a 3x3 array
        for (i = 0; i < 3; i = i + 1) begin
            for (j = 0; j < 3; j = j + 1) begin
                pixel[i][j] = pixels[(i*3+j)*8 +: 8];
            end
        end

        // Calculate gradients Gx and Gy using Sobel operator
        Gx = (pixel[0][2] + 2*pixel[1][2] + pixel[2][2]) - (pixel[0][0] + 2*pixel[1][0] + pixel[2][0]);
        Gy = (pixel[2][0] + 2*pixel[2][1] + pixel[2][2]) - (pixel[0][0] + 2*pixel[0][1] + pixel[0][2]);

        // Calculate gradient magnitude
        gradient_magnitude = (Gx < 0 ? -Gx : Gx) + (Gy < 0 ? -Gy : Gy);
        if (gradient_magnitude > 255) gradient_magnitude = 255; // Clamp to 8 bits
    end
endmodule