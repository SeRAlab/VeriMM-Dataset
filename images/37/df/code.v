module sobel_edge_detection(
    input [8:0] pixel_block, // 3x3 pixel block, each pixel is 8 bits for grayscale
    output reg [7:0] edge_strength // Edge strength output
);

    wire signed [13:0] Gx; // Gradient in x direction
    wire signed [13:0] Gy; // Gradient in y direction

    // Sobel kernels
    // Gx kernel: [-1 0 1; -2 0 2; -1 0 1]
    // Gy kernel: [-1 -2 -1; 0 0 0; 1 2 1]
    
    assign Gx = (-1 * pixel_block[8:0]) + (1 * pixel_block[16:8]) +
                (-2 * pixel_block[24:16]) + (2 * pixel_block[32:24]) +
                (-1 * pixel_block[40:32]) + (1 * pixel_block[48:40]);

    assign Gy = (-1 * pixel_block[8:0]) + (-2 * pixel_block[16:8]) +
                (-1 * pixel_block[24:16]) + (1 * pixel_block[32:24]) +
                (2 * pixel_block[40:32]) + (1 * pixel_block[48:40]);

    always @(*) begin
        // Calculate the edge strength
        edge_strength = (Gx > 0 ? Gx : -Gx) + (Gy > 0 ? Gy : -Gy);
        if (edge_strength > 255)
            edge_strength = 255; // Clamp to 8 bits
    end

endmodule