module kalman_filter (
    input clk,
    input reset,
    input [15:0] z,  // noisy measurement
    input [15:0] u,  // control input
    output reg [15:0] x_hat // estimated position
);
    parameter A = 16'h0001; // State transition
    parameter B = 16'h0000; // Control input effect
    parameter H = 16'h0001; // Measurement matrix
    parameter Q = 16'h0001; // Process noise covariance
    parameter R = 16'h0001; // Measurement noise covariance

    reg [15:0] P; // estimation error covariance
    reg [15:0] K; // Kalman gain
    reg [15:0] z_pred; // predicted measurement

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_hat <= 16'b0;
            P <= 16'h0001; // Initial estimation error covariance
        end else begin
            // Prediction step
            x_hat <= A * x_hat + B * u; // Update state estimate
            P <= A * P * A + Q; // Update estimation error covariance

            // Update step
            z_pred <= H * x_hat; // Predicted measurement
            K <= P * H / (H * P * H + R); // Calculate Kalman gain
            x_hat <= x_hat + K * (z - z_pred); // Update state estimate
            P <= (16'h0001 - K * H) * P; // Update estimation error covariance
        end
    end
endmodule