module kalman_filter (
    input wire clk,
    input wire rst,
    input wire [15:0] position_meas,
    input wire [15:0] velocity_meas,
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_velocity
);

    reg [15:0] P; // error covariance
    reg [15:0] K; // Kalman gain
    reg [15:0] Q; // process noise covariance
    reg [15:0] R; // measurement noise covariance

    initial begin
        estimated_position = 0;
        estimated_velocity = 0;
        P = 16'hFFFF; // initial error covariance
        K = 0;
        Q = 16'h0001; // process noise
        R = 16'h0004; // measurement noise
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimated_position <= 0;
            estimated_velocity <= 0;
            P <= 16'hFFFF;
        end else begin
            // Predict step
            estimated_position <= estimated_position + estimated_velocity; // simple position update
            P <= P + Q; // update error covariance

            // Update step
            K <= P / (P + R); // calculate Kalman gain
            estimated_position <= estimated_position + K * (position_meas - estimated_position);
            estimated_velocity <= estimated_velocity + K * (velocity_meas - estimated_velocity);
            P <= (1 - K) * P; // update error covariance
        end
    end
endmodule