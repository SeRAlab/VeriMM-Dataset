module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    output reg [15:0] estimated_state
);
    reg [15:0] estimate;
    reg [15:0] error_covariance;
    reg [15:0] kalman_gain;

    parameter REAL_PROCESS_NOISE = 16'h0001; // Process noise covariance
    parameter MEASUREMENT_NOISE = 16'h0002; // Measurement noise covariance

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimate <= 16'h0000; // Initial estimate
            error_covariance <= 16'hFFFF; // Initial error covariance
        end else begin
            // Prediction Step
            estimate <= estimate; // State prediction (no control input here)
            error_covariance <= error_covariance + REAL_PROCESS_NOISE;

            // Update Step
            kalman_gain <= error_covariance / (error_covariance + MEASUREMENT_NOISE);
            estimate <= estimate + kalman_gain * (measurement - estimate);
            error_covariance <= (16'hFFFF - kalman_gain) * error_covariance;

            // Output the estimated state
            estimated_state <= estimate;
        end
    end
endmodule