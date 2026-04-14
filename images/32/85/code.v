module canny_threshold (
    input [7:0] pixel_value,  // 8-bit pixel intensity
    input [7:0] low_threshold, // Low threshold for edge detection
    input [7:0] high_threshold, // High threshold for edge detection
    output reg edge_detected    // Output: 1 if edge detected, else 0
);
    always @(*) begin
        if (pixel_value >= high_threshold)
            edge_detected = 1; // Strong edge
        else if (pixel_value >= low_threshold)
            edge_detected = 1; // Weak edge
        else
            edge_detected = 0; // Not an edge
    end
endmodule