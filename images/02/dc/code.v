module kalman_filter(
    input clk,
    input reset,
    input [15:0] z,      // Sensor measurement
    input [15:0] x_hat,  // Previous estimate
    output reg [15:0] x_est, // Updated estimate
    output reg [15:0] K   // Kalman gain
);
    parameter Q = 16'd1;   // Process noise covariance
    parameter R = 16'd4;   // Measurement noise covariance
    reg [15:0] P;          // Estimate uncertainty

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_est <= 16'd0;
            K <= 16'd0;
            P <= 16'd1;
        end else begin
            // Prediction Update
            P <= P + Q;

            // Measurement Update
            K <= P / (P + R);
            x_est <= x_hat + K * (z - x_hat);
            P <= (1 - K) * P;
        end
    end
endmodule