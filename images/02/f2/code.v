module kalman_filter(
    input wire clk,
    input wire reset,
    input wire [15:0] measurement, // Noisy measurement input
    output reg [15:0] estimated_position, // Estimated position output
    output reg [15:0] estimated_covariance // Estimated covariance output
);
    // Kalman gain and parameters
    reg [15:0] kalman_gain;
    reg [15:0] process_noise_variance = 16'd1; // Process noise variance
    reg [15:0] measurement_noise_variance = 16'd5; // Measurement noise variance

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_position <= 16'd0;
            estimated_covariance <= 16'd10; // Initial covariance
        end else begin
            // Update Kalman gain
            kalman_gain <= estimated_covariance / (estimated_covariance + measurement_noise_variance);
            
            // Update estimated position
            estimated_position <= estimated_position + kalman_gain * (measurement - estimated_position);
            
            // Update estimated covariance
            estimated_covariance <= (1 - kalman_gain) * estimated_covariance + process_noise_variance;
        end
    end
endmodule