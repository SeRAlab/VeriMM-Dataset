module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement, // Measured sensor value
    input [15:0] prediction,   // Predicted value from a model
    input [15:0] measurement_noise, // Measurement noise covariance
    input [15:0] model_noise,  // Model noise covariance
    output reg [15:0] estimate, // Updated estimate
    output reg [15:0] error_covariance // Updated error covariance
);
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 16'b0;
            error_covariance <= 16'b0;
        end else begin
            // Calculate Kalman Gain
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);

            // Update estimate
            estimate <= estimate + kalman_gain * (measurement - estimate);

            // Update error covariance
            error_covariance <= (16'hFFFF - kalman_gain) * error_covariance + model_noise;
        end
    end
endmodule