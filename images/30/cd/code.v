module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement, // Noisy position measurement
    input [15:0] control_input, // Control input (velocity)
    output reg [15:0] position_estimate // Estimated position
);

// Kalman filter parameters
reg [15:0] k_gain; // Kalman gain
reg [15:0] process_noise; // Process noise covariance
reg [15:0] measurement_noise; // Measurement noise covariance
reg [15:0] estimate_covariance; // Estimate covariance

always @(posedge clk or posedge rst) begin
    if (rst) begin
        position_estimate <= 0;
        k_gain <= 0;
        process_noise <= 16'h0001; // Small process noise
        measurement_noise <= 16'h0005; // Larger measurement noise
        estimate_covariance <= 16'h0001; // Initial estimate covariance
    end else begin
        // Prediction step
        position_estimate <= position_estimate + control_input;

        // Update step
        k_gain <= estimate_covariance / (estimate_covariance + measurement_noise);
        position_estimate <= position_estimate + k_gain * (measurement - position_estimate);
        estimate_covariance <= (1 - k_gain) * estimate_covariance + process_noise;
    end
end
endmodule