module kalman_filter (
    input clk,
    input rst,
    input [7:0] sensor_a,
    input [7:0] sensor_b,
    output reg [7:0] estimated_state,
    output reg [7:0] estimated_uncertainty
);

    // Kalman filter parameters
    reg [7:0] process_noise_cov = 8'd5; // Process noise covariance
    reg [7:0] measurement_noise_cov = 8'd3; // Measurement noise covariance
    reg [7:0] kalman_gain; // Kalman gain
    reg [7:0] temp_state; // Temporary state variable

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            estimated_state <= 8'd0;
            estimated_uncertainty <= 8'd10; // Initial uncertainty
        end else begin
            // Prediction step
            temp_state = estimated_state;

            // Update Kalman gain
            kalman_gain = estimated_uncertainty / (estimated_uncertainty + measurement_noise_cov);

            // Update estimate
            estimated_state = temp_state + kalman_gain * (sensor_a + sensor_b - temp_state);
            // Update uncertainty
            estimated_uncertainty = (8'd1 - kalman_gain) * estimated_uncertainty + process_noise_cov;
        end
    end
endmodule