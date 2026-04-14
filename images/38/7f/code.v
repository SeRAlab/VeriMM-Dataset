module sobel_edge_detection (
    input [8:0] pixel_matrix, // 3x3 matrix flattened to 9 bits
    output [9:0] gradient_magnitude // Output gradient magnitude
);

    wire [9:0] gx; // Gradient in x direction
    wire [9:0] gy; // Gradient in y direction

    // Calculate gx (horizontal gradient)
    assign gx = 
        -1 * pixel_matrix[0] + 1 * pixel_matrix[2] +
        -2 * pixel_matrix[3] + 2 * pixel_matrix[5] +
        -1 * pixel_matrix[6] + 1 * pixel_matrix[8];

    // Calculate gy (vertical gradient)
    assign gy = 
        -1 * pixel_matrix[0] - 2 * pixel_matrix[1] - 1 * pixel_matrix[2] +
        1 * pixel_matrix[6] + 2 * pixel_matrix[7] + 1 * pixel_matrix[8];

    // Calculate gradient magnitude
    assign gradient_magnitude = (gx * gx + gy * gy) ** 0.5; // Simple magnitude calculation (you may need to modify for synthesis)

endmodule