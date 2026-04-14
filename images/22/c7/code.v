module threshold_detector (
    input [7:0] pixel_value, // 8-bit grayscale pixel
    input [7:0] threshold,    // Threshold value
    output reg edge_detected  // Output: 1 if edge is detected, 0 otherwise
);
    always @(*) begin
        if (pixel_value > threshold)
            edge_detected = 1'b1; // Edge detected
        else
            edge_detected = 1'b0; // No edge detected
    end
endmodule