module KalmanFilter (
    input wire clk,
    input wire reset,
    input wire signed [15:0] input1,
    input wire signed [15:0] input2,
    input wire signed [15:0] control,
    output reg signed [15:0] output_estimate
);
    parameter signed [15:0] Q = 16'h0001; // Process noise covariance
    parameter signed [15:0] R = 16'h0005; // Measurement noise covariance
    reg signed [15:0] x_hat; // Estimated state
    reg signed [15:0] P; // Estimate uncertainty
    reg signed [15:0] K; // Kalman gain

    // Initialization
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_hat <= 16'h0000; // Initial estimate
            P <= 16'h0001; // Initial uncertainty
        end else begin
            // Prediction step
            x_hat <= x_hat + control; // Predicted state
            P <= P + Q; // Predicted uncertainty

            // Measurement update
            K <= P / (P + R); // Kalman gain
            x_hat <= x_hat + K * (input1 + input2) / 2 - x_hat; // Update estimate
            P <= (1 - K) * P; // Update uncertainty
            
            // Output the estimate
            output_estimate <= x_hat;
        end
    end
endmodule