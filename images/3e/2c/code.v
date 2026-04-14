module KalmanFilter (
    input clk,
    input reset,
    input [15:0] z_pos,        // Position measurement
    input [15:0] z_vel,        // Velocity measurement
    input [15:0] x_prev_pos,   // Previous position estimate
    input [15:0] x_prev_vel,   // Previous velocity estimate
    input [15:0] R_pos,        // Measurement noise covariance for position
    input [15:0] R_vel,        // Measurement noise covariance for velocity
    output reg [15:0] x_pos,   // Updated position estimate
    output reg [15:0] x_vel    // Updated velocity estimate
);
    reg [15:0] K_pos;           // Kalman gain for position
    reg [15:0] K_vel;           // Kalman gain for velocity
    reg [15:0] P_pos;           // Error covariance for position
    reg [15:0] P_vel;           // Error covariance for velocity

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_pos <= 16'b0;
            x_vel <= 16'b0;
            P_pos <= 16'd1000;  // Initial covariance
            P_vel <= 16'd1000;  // Initial covariance
        end else begin
            // Update Kalman gain
            K_pos <= P_pos / (P_pos + R_pos);
            K_vel <= P_vel / (P_vel + R_vel);
            
            // Update estimates
            x_pos <= x_prev_pos + K_pos * (z_pos - x_prev_pos);
            x_vel <= x_prev_vel + K_vel * (z_vel - x_prev_vel);
            
            // Update error covariance
            P_pos <= (1 - K_pos) * P_pos;
            P_vel <= (1 - K_vel) * P_vel;
        end
    end
endmodule