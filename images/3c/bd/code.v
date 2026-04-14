module sobel_edge_detector (
    input [8:0] pixels, // 9-bit input representing the 3x3 pixel values
    output reg edge_detected // 1-bit output indicating edge detection
);

    wire signed [11:0] Gx, Gy;
    
    // Sobel operator kernels
    // Gx kernel
    assign Gx = (pixels[0] * -1) + (pixels[1] * 0) + (pixels[2] * 1) +
                (pixels[3] * -2) + (pixels[4] * 0) + (pixels[5] * 2) +
                (pixels[6] * -1) + (pixels[7] * 0) + (pixels[8] * 1);
    
    // Gy kernel
    assign Gy = (pixels[0] * -1) + (pixels[3] * -2) + (pixels[6] * -1) +
                (pixels[2] * 1) + (pixels[5] * 2) + (pixels[8] * 1);
    
    // Edge detection based on magnitude of the gradient
    always @(*) begin
        if (Gx * Gx + Gy * Gy > 255) // Thresholding the magnitude
            edge_detected = 1;
        else
            edge_detected = 0;
    end
endmodule