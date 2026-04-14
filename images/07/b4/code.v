module edge_detector (
    input [7:0] pixel_value, // 8-bit grayscale pixel value
    input [7:0] threshold,   // 8-bit threshold value
    output reg edge_detected // 1-bit output for edge detection
);

always @(*) begin
    if (pixel_value > threshold)
        edge_detected = 1'b1; // Edge detected
    else
        edge_detected = 1'b0; // No edge detected
end

endmodule