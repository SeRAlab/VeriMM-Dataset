module kalman_filter (
    input clk,
    input reset,
    input signed [15:0] measure_pos, // Measured position
    input signed [15:0] measure_vel, // Measured velocity
    output reg signed [15:0] est_pos, // Estimated position
    output reg signed [15:0] est_vel  // Estimated velocity
);

    // Kalman filter parameters
    parameter signed [15:0] Q = 16'h1; // Process noise covariance
    parameter signed [15:0] R = 16'h10; // Measurement noise covariance
    reg signed [15:0] P; // Estimation error covariance
    reg signed [15:0] K; // Kalman gain
    reg signed [15:0] pred_pos; // Predicted position
    reg signed [15:0] pred_vel; // Predicted velocity

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            est_pos <= 16'h0;
            est_vel <= 16'h0;
            P <= 16'h1;
        end else begin
            // Predict step
            pred_pos <= est_pos + est_vel; // Simplified prediction
            pred_vel <= est_vel;
            
            // Update step
            K <= P / (P + R); // Kalman gain
            est_pos <= pred_pos + K * (measure_pos - pred_pos);
            est_vel <= pred_vel + K * (measure_vel - pred_vel);
            
            // Update estimation error covariance
            P <= (1 - K) * P + Q;
        end
    end
endmodule