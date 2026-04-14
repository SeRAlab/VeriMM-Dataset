module kalman_filter (
    input wire clk,
    input wire reset,
    input wire [15:0] measurement, // Noisy measurement
    output reg [15:0] estimate // Estimated position
);

    reg [15:0] x; // Estimated state
    reg [15:0] P; // Estimation error covariance
    reg [15:0] K; // Kalman gain
    parameter R = 16'd1; // Measurement noise covariance
    parameter Q = 16'd10; // Process noise covariance

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            x <= 16'd0;
            P <= 16'd1;
            estimate <= 16'd0;
        end else begin
            // Prediction update
            P <= P + Q;

            // Measurement update
            K <= P / (P + R);
            x <= x + K * (measurement - x);
            P <= (1 - K) * P;

            // Output the estimate
            estimate <= x;
        end
    end
endmodule