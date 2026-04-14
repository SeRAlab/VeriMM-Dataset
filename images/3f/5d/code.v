module kalman_filter(
    input clk,
    input reset,
    input [15:0] measurement1,
    input [15:0] measurement2,
    output reg [15:0] estimated_position
);
    reg [15:0] x; // Estimated position
    reg [15:0] p; // Estimate error covariance
    reg [15:0] k; // Kalman gain
    
    initial begin
        x = 0;
        p = 16'hFFFF; // Initial large error covariance
        k = 16'h0001; // Fixed Kalman gain
    end
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 0;
            p <= 16'hFFFF;
        end else begin
            // Prediction update
            x <= x; // No control input, keep x the same
            p <= p + 16'h0001; // Increase the error covariance
            
            // Measurement update
            x <= x + k * ( (measurement1 + measurement2) >> 1 - x ); // Average of measurements
            p <= (16'hFFFF - k) * p; // Update error covariance
        end
    end
endmodule