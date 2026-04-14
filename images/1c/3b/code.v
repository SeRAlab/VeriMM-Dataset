module KalmanFilter(
    input clk,
    input reset,
    input [15:0] sensor1_position,
    input [15:0] sensor2_position,
    input [15:0] sensor1_velocity,
    input [15:0] sensor2_velocity,
    output reg [15:0] estimated_position,
    output reg [15:0] estimated_velocity
);
    reg [15:0] P; // estimate uncertainty
    reg [15:0] K; // Kalman gain
    reg [15:0] R = 16'h000A; // measurement noise covariance
    reg [15:0] Q = 16'h0001; // process noise covariance

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_position <= 16'h0000;
            estimated_velocity <= 16'h0000;
            P <= 16'hFFFF; // large initial uncertainty
        end else begin
            // Prediction step
            estimated_position <= estimated_position + estimated_velocity;
            P <= P + Q;

            // Measurement update
            K <= P / (P + R); // Kalman gain
            estimated_position <= estimated_position + K * (sensor1_position + sensor2_position) / 2 - estimated_position;
            estimated_velocity <= estimated_velocity + K * (sensor1_velocity + sensor2_velocity) / 2 - estimated_velocity;

            // Update uncertainty
            P <= (16'hFFFF - K) * P;
        end
    end
endmodule