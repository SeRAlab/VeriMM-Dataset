module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    input [15:0] prediction,
    input [15:0] measurement_noise,
    input [15:0] prediction_noise,
    output reg [15:0] updated_estimate,
    output reg [15:0] kalman_gain
);
    reg [15:0] error_covariance;
    
    // Initial state
    initial begin
        updated_estimate = 0;
        error_covariance = 1; // Initial error covariance
        kalman_gain = 0;
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_estimate <= 0;
            error_covariance <= 1;
            kalman_gain <= 0;
        end else begin
            // Prediction update step
            error_covariance <= error_covariance + prediction_noise;

            // Kalman Gain
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);

            // Measurement update step
            updated_estimate <= updated_estimate + kalman_gain * (measurement - updated_estimate);
            error_covariance <= (1 - kalman_gain) * error_covariance;
        end
    end
endmodule