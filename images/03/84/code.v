module hough_transform (
    input [3:0] angle,
    input [3:0] distance,
    output reg line_detected
);
    
    always @(*) begin
        // Simple line detection logic
        if (angle >= 0 && angle < 90 && distance <= 15) 
            line_detected = 1;
        else 
            line_detected = 0;
    end
endmodule