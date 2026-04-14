module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement, // Noisy position measurement
    output reg [15:0] position_estimate,
    output reg [15:0] velocity_estimate
);

    // State variables
    reg [15:0] state_position; // Estimated position
    reg [15:0] state_velocity; // Estimated velocity
    reg [15:0] P; // Error covariance
    reg [15:0] K; // Kalman gain

    // Kalman filter parameters
    parameter Q = 16'd1; // Process noise covariance
    parameter R = 16'd10; // Measurement noise covariance

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_position <= 16'd0;
            state_velocity <= 16'd0;
            P <= 16'd1; // Initial guess of error covariance
        end else begin
            // Kalman filter equations
            // Prediction
            state_position <= state_position + state_velocity; // Update position
            P <= P + Q; // Update error covariance

            // Kalman gain
            K <= P / (P + R);
            // Update state estimates
            state_position <= state_position + K * (measurement - state_position);
            state_velocity <= state_velocity; // Assume constant velocity for simplicity

            position_estimate <= state_position;
            velocity_estimate <= state_velocity;
        end
    end
endmodule