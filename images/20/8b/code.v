module kalman_filter (
    input clk,
    input rst,
    input signed [15:0] measurement,
    output reg signed [15:0] estimate
);
    reg signed [15:0] Q; // process noise covariance
    reg signed [15:0] R; // measurement noise covariance
    reg signed [15:0] K; // Kalman gain
    reg signed [15:0] prev_estimate;

    // Initialize values
    initial begin
        Q = 16'd1; // Example value for process noise
        R = 16'd10; // Example value for measurement noise
        estimate = 16'd0;
        prev_estimate = 16'd0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimate <= 16'd0;
            prev_estimate <= 16'd0;
        end else begin
            // Calculate Kalman gain
            K <= (prev_estimate + Q) / (prev_estimate + Q + R);
            // Update estimate
            estimate <= prev_estimate + K * (measurement - prev_estimate);
            // Update previous estimate
            prev_estimate <= estimate;
        end
    end
endmodule