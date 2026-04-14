module kalman_filter(
    input clk,
    input reset,
    input [15:0] measurement,   // Noisy measurement
    output reg [15:0] filtered_output // Filtered output
);
    reg [15:0] estimate; // Current state estimate
    reg [15:0] error_cov; // Current error covariance
    reg [15:0] kalman_gain; // Kalman gain

    parameter [15:0] R = 16'h100; // Measurement noise covariance
    parameter [15:0] Q = 16'h10;  // Process noise covariance
    parameter [15:0] P = 16'hFF;  // Initial error covariance

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 16'h0;
            error_cov <= P;
            filtered_output <= 16'h0;
        end else begin
            // Prediction update
            estimate <= estimate; // Assuming constant velocity model
            error_cov <= error_cov + Q;

            // Measurement update
            kalman_gain <= error_cov / (error_cov + R);
            estimate <= estimate + (kalman_gain * (measurement - estimate));
            error_cov <= (16'hFFFF - kalman_gain) * error_cov;

            // Output the filtered estimate
            filtered_output <= estimate;
        end
    end
endmodule