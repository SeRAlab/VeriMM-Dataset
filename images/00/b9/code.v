module canny_edge_detection (
    input [8:0] pixels, // 3x3 pixel input
    input [3:0] threshold, // threshold for edge detection
    output reg edge_detected // output flag for edge detection
);
    wire [7:0] gx, gy; // gradient in x and y directions
    wire [7:0] gradient_magnitude; // magnitude of the gradient
    
    // Simple Sobel operator implementation
    assign gx = (pixels[8] + 2*pixels[5] + pixels[2]) - (pixels[0] + 2*pixels[3] + pixels[6]); // Gx
    assign gy = (pixels[0] + 2*pixels[1] + pixels[2]) - (pixels[6] + 2*pixels[7] + pixels[8]); // Gy

    assign gradient_magnitude = (gx * gx + gy * gy); // Gradient magnitude (squared)

    always @(*) begin
        if (gradient_magnitude > threshold) 
            edge_detected = 1'b1; // Edge detected
        else 
            edge_detected = 1'b0; // No edge detected
    end
endmodule