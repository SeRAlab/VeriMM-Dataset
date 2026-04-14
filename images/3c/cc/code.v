module kalman_filter (
    input clk,
    input rst,
    input signed [15:0] z, // Measurement
    input signed [15:0] q, // Process noise
    input signed [15:0] r, // Measurement noise
    output reg signed [15:0] x_est // Estimated state
);
    reg signed [15:0] x_pred; // Predicted state
    reg signed [15:0] P; // Estimate error covariance
    reg signed [15:0] K; // Kalman gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x_est <= 0;
            P <= 16'hFFFF; // initial large uncertainty
        end else begin
            // Prediction step
            x_pred <= x_est; // assuming no control input
            P <= P + q; // Increase uncertainty due to process noise

            // Update step
            K <= P / (P + r); // Kalman gain
            x_est <= x_pred + K * (z - x_pred); // Update estimate
            P <= (16'hFFFF - K) * P; // Update uncertainty
        end
    end
endmodule