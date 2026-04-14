module kalman_filter(
    input clk,
    input reset,
    input [15:0] measurement,
    output reg [15:0] estimate
);
    reg [15:0] process_noise = 16'h000A; // Process noise covariance
    reg [15:0] measurement_noise = 16'h0005; // Measurement noise covariance
    reg [15:0] kalman_gain;
    reg [15:0] prev_estimate;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 16'h0000;
            prev_estimate <= 16'h0000;
        end else begin
            // Prediction step
            prev_estimate <= estimate;

            // Calculate Kalman Gain
            kalman_gain <= (prev_estimate + process_noise) / (prev_estimate + process_noise + measurement_noise);

            // Update step
            estimate <= prev_estimate + kalman_gain * (measurement - prev_estimate);
        end
    end
endmodule