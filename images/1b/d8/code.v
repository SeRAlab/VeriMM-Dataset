module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement, // Noisy sensor measurement
    input [15:0] prediction,   // Predicted measurement
    output reg [15:0] estimate  // Estimated state output
);
    reg [15:0] k_gain; // Kalman Gain
    reg [15:0] process_noise_cov = 16'h0001; // Process Noise Covariance
    reg [15:0] measurement_noise_cov = 16'h0004; // Measurement Noise Covariance
    reg [15:0] prior_estimate = 16'h0000; // Initial state

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 16'h0000;
            prior_estimate <= 16'h0000;
        end else begin
            // Calculate Kalman Gain
            k_gain <= (process_noise_cov) / (process_noise_cov + measurement_noise_cov);
            
            // Update estimate
            estimate <= prior_estimate + k_gain * (measurement - prior_estimate);
            
            // Update prior estimate for next cycle
            prior_estimate <= estimate;
        end
    end
endmodule