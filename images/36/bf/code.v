module kalman_filter (
    input clk,
    input rst,
    input signed [15:0] sensor1,
    input signed [15:0] sensor2,
    input signed [15:0] estimated_position,
    output reg signed [15:0] refined_position
);
    // Kalman filter parameters (for simplicity)
    parameter signed [15:0] Q = 16'h0001; // Process noise covariance
    parameter signed [15:0] R = 16'h0004; // Measurement noise covariance
    reg signed [15:0] P; // Estimation error covariance
    reg signed [15:0] K; // Kalman gain
    reg signed [15:0] z; // Measurement
    reg signed [15:0] x; // Updated estimate

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            refined_position <= 16'h0000;
            P <= 16'h0001; // Initial guess for P
        end else begin
            // Prediction step
            P <= P + Q;

            // Measurement update step
            z <= (sensor1 + sensor2) >> 1; // Average of sensors
            K <= P / (P + R); // Kalman gain
            x <= estimated_position + K * (z - estimated_position); // Update the estimate
            P <= (16'h0001 - K) * P; // Update the error covariance

            refined_position <= x; // Output the refined position
        end
    end
endmodule