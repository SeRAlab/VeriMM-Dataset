module sobel_edge_detection(
    input [7:0] pixel_00, pixel_01, pixel_02,
    input [7:0] pixel_10, pixel_11, pixel_12,
    input [7:0] pixel_20, pixel_21, pixel_22,
    output [15:0] edge_magnitude
);
    wire signed [16:0] Gx, Gy;
    
    // Calculate Gx and Gy using Sobel operators
    assign Gx = (pixel_00 * -1) + (pixel_01 * 0) + (pixel_02 * 1) +
                (pixel_10 * -2) + (pixel_11 * 0) + (pixel_12 * 2) +
                (pixel_20 * -1) + (pixel_21 * 0) + (pixel_22 * 1);
                
    assign Gy = (pixel_00 * -1) + (pixel_10 * -2) + (pixel_20 * -1) +
                (pixel_02 * 1) + (pixel_12 * 2) + (pixel_22 * 1);
                
    // Calculate the edge magnitude
    assign edge_magnitude = Gx * Gx + Gy * Gy; // Using squared values for magnitude calculation

endmodule