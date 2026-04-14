module kalman_filter (
    input clk,
    input reset,
    input signed [15:0] measurement,
    input signed [15:0] control_input,
    output reg signed [15:0] state_estimate,
    output reg signed [15:0] error_covariance
);
    reg signed [15:0] Q; // Process noise covariance
    reg signed [15:0] R; // Measurement noise covariance
    reg signed [15:0] K; // Kalman gain

    initial begin
        Q = 16'd1; // Example value
        R = 16'd5; // Example value
        state_estimate = 16'd0;
        error_covariance = 16'd1;
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_estimate <= 16'd0;
            error_covariance <= 16'd1;
        end else begin
            // Prediction update
            error_covariance <= error_covariance + Q;

            // Measurement update
            K <= error_covariance / (error_covariance + R);
            state_estimate <= state_estimate + K * (measurement - state_estimate);
            error_covariance <= (16'd1 - K) * error_covariance;
        end
    end
endmodule