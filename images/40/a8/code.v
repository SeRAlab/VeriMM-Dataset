module kalman_filter #(
    parameter STATE_DIM = 2,
    parameter MEASUREMENT_DIM = 2
)(
    input clk,
    input reset,
    input [15:0] z1, // measurement from sensor 1
    input [15:0] z2, // measurement from sensor 2
    input [15:0] A, // state transition matrix (flattened)
    input [15:0] H, // measurement matrix (flattened)
    input [15:0] Q, // process noise covariance (flattened)
    input [15:0] R, // measurement noise covariance (flattened)
    output reg [15:0] x_est, // estimated state
    output reg [15:0] p_est // estimated covariance
);

    reg [15:0] x_pred;
    reg [15:0] p_pred;
    reg [15:0] K; // Kalman gain
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x_est <= 0;
            p_est <= 0;
        end else begin
            // Prediction step
            x_pred <= A * x_est; // State prediction
            p_pred <= A * p_est * A + Q; // Covariance prediction
            
            // Update step
            K <= p_pred * H / (H * p_pred * H + R); // Kalman gain
            x_est <= x_pred + K * (z1 + z2 - H * x_pred); // Update state estimate
            p_est <= (1 - K * H) * p_pred; // Update covariance estimate
        end
    end
endmodule