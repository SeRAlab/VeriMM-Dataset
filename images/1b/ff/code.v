module hough_transform (
    input wire [63:0] binary_image,
    output reg [179:0] hough_space // 180 possible angles
);

    integer x, y, angle;
    reg [3:0] r; // radius for line length, max 64 bits => 6 bits (0-63)
    reg [63:0] theta; // angle accumulator

    always @(*) begin
        // Initialize hough_space
        hough_space = 180'b0;

        // Iterate over each pixel in the binary image
        for (y = 0; y < 8; y = y + 1) begin
            for (x = 0; x < 8; x = x + 1) begin
                if (binary_image[y*8 + x] == 1) begin // If the pixel is part of a line
                    // Check for potential angles
                    for (angle = 0; angle < 180; angle = angle + 1) begin
                        r = (x * $cos(angle * 3.14159 / 180)) + (y * $sin(angle * 3.14159 / 180));
                        if (r >= 0 && r < 64) begin
                            hough_space[angle] = hough_space[angle] + 1; // Increment pixel count
                        end
                    end
                end
            end
        end
    end
endmodule