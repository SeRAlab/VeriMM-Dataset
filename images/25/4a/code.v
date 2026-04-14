module KalmanFilter (
    input clk,
    input rst,
    input [15:0] noisy_measurement,
    output reg [15:0] filtered_value
);
    parameter Q = 16'h0001; // process noise covariance
    parameter R = 16'h0004; // measurement noise covariance
    reg [15:0] x; // estimated state
    reg [15:0] p; // estimation error covariance
    reg [15:0] k; // Kalman gain

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            x <= 16'h0000;
            p <= 16'h0001; // initial estimation error covariance
            filtered_value <= 16'h0000;
        end else begin
            // Prediction update
            p <= p + Q; 

            // Measurement update
            k <= p / (p + R); // Compute Kalman gain
            x <= x + k * (noisy_measurement - x); // Update state estimate
            p <= (16'h0001 - k) * p; // Update estimation error covariance

            filtered_value <= x; // Output the estimated state
        end
    end
endmodule