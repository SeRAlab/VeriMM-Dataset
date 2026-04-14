module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement, // noisy measurement
    input [15:0] estimated_position, // previous estimated position
    input [15:0] process_noise, // process noise covariance (Q)
    input [15:0] measurement_noise, // measurement noise covariance (R)
    output reg [15:0] new_estimated_position // new estimated position
);
    reg [15:0] predicted_position;
    reg [15:0] predicted_covariance;
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            new_estimated_position <= 16'd0;
            predicted_position <= 16'd0;
            predicted_covariance <= 16'd0;
        end else begin
            // Prediction step
            predicted_position <= estimated_position; // Assuming constant velocity, could be improved
            predicted_covariance <= predicted_covariance + process_noise;

            // Update step
            kalman_gain <= predicted_covariance / (predicted_covariance + measurement_noise);
            new_estimated_position <= predicted_position + (kalman_gain * (measurement - predicted_position));
        end
    end
endmodule