module sobel_edge_detection(
    input [8:0] pixel_values, // 9-bit input for 3x3 pixels
    output reg [7:0] edge_magnitude // 8-bit output for edge magnitude
);
    wire signed [10:0] Gx, Gy; // Gradient in X and Y directions
    wire [7:0] abs_Gx, abs_Gy; // Absolute values of gradients

    // Sobel kernel for X direction
    assign Gx = 
        (pixel_values[8] + 2 * pixel_values[7] + pixel_values[6]) - // top row
        (pixel_values[2] + 2 * pixel_values[1] + pixel_values[0]);  // bottom row

    // Sobel kernel for Y direction
    assign Gy = 
        (pixel_values[6] + 2 * pixel_values[3] + pixel_values[0]) - // left column
        (pixel_values[8] + 2 * pixel_values[5] + pixel_values[2]);  // right column

    // Compute absolute values
    assign abs_Gx = (Gx < 0) ? -Gx[9:2] : Gx[9:2]; // right shift to keep in 8 bits
    assign abs_Gy = (Gy < 0) ? -Gy[9:2] : Gy[9:2]; // right shift to keep in 8 bits

    // Compute magnitude
    always @(*) begin
        edge_magnitude = abs_Gx + abs_Gy; // Simplified magnitude computation
    end

endmodule