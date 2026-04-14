module canny_edge_detection (
    input [8:0] pixel_matrix, // 3x3 pixel matrix flattened
    input [7:0] threshold,
    output reg edge_detected
);
    wire [7:0] gx, gy; // gradients in x and y directions
    wire [15:0] gradient_magnitude;

    // Simple Sobel operators for gradient calculation
    assign gx = (pixel_matrix[2:0] + 2 * pixel_matrix[5:3] + pixel_matrix[8:6]) -
                (pixel_matrix[0:0] + 2 * pixel_matrix[3:1] + pixel_matrix[6:4]);
                
    assign gy = (pixel_matrix[0:0] + 2 * pixel_matrix[1:1] + pixel_matrix[2:2]) -
                (pixel_matrix[6:6] + 2 * pixel_matrix[7:7] + pixel_matrix[8:8]);

    assign gradient_magnitude = gx * gx + gy * gy; // Gradient magnitude

    always @* begin
        if (gradient_magnitude[15:8] > threshold) // Check against threshold
            edge_detected = 1'b1; // Edge detected
        else
            edge_detected = 1'b0; // No edge detected
    end
endmodule