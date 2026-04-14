module kalman_filter (
    input clk,
    input rst,
    input [15:0] z_pos,      // Position measurement
    input [15:0] z_vel,      // Velocity measurement
    input [15:0] q,          // Process noise covariance
    input [15:0] r,          // Measurement noise covariance
    output reg [15:0] x_pos,  // Estimated position
    output reg [15:0] x_vel   // Estimated velocity
);
    reg [15:0] p_pos;  // Estimation error covariance for position
    reg [15:0] p_vel;  // Estimation error covariance for velocity
    reg [15:0] k_pos;  // Kalman gain for position
    reg [15:0] k_vel;  // Kalman gain for velocity

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_pos <= 16'b0;
            x_vel <= 16'b0;
            p_pos <= 16'b0;
            p_vel <= 16'b0;
        end else begin
            // Prediction step
            p_pos <= p_pos + q;
            p_vel <= p_vel + q;

            // Update step for position
            k_pos <= p_pos / (p_pos + r);
            x_pos <= x_pos + k_pos * (z_pos - x_pos);
            p_pos <= (16'b1 - k_pos) * p_pos;

            // Update step for velocity
            k_vel <= p_vel / (p_vel + r);
            x_vel <= x_vel + k_vel * (z_vel - x_vel);
            p_vel <= (16'b1 - k_vel) * p_vel;
        end
    end
endmodule