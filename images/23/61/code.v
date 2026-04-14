module kalman_filter(
    input clk,
    input rst,
    input [15:0] measurement,  // Sensor measurement
    input [15:0] prev_estimate, // Previous state estimate
    input [15:0] process_noise, // Process noise covariance
    input [15:0] measurement_noise, // Measurement noise covariance
    output reg [15:0] estimate   // Updated state estimate
);
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimate <= 16'b0;
            kalman_gain <= 16'b0;
        end else begin
            // Calculate Kalman gain
            kalman_gain <= (process_noise) / (process_noise + measurement_noise);
            // Update estimate
            estimate <= prev_estimate + kalman_gain * (measurement - prev_estimate);
        end
    end
endmodule