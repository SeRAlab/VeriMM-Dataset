module kalman_filter (
    input clk,
    input reset,
    input [15:0] predicted_state,
    input [15:0] measurement,
    input [15:0] measurement_noise_cov,
    input [15:0] process_noise_cov,
    output reg [15:0] updated_state,
    output reg [15:0] updated_covariance
);

reg [15:0] kalman_gain;
reg [15:0] predicted_covariance;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        updated_state <= 16'd0;
        updated_covariance <= 16'd0;
    end else begin
        // Calculate the predicted covariance
        predicted_covariance <= process_noise_cov + updated_covariance;

        // Calculate the Kalman Gain
        kalman_gain <= predicted_covariance / (predicted_covariance + measurement_noise_cov);

        // Update state
        updated_state <= predicted_state + (kalman_gain * (measurement - predicted_state));

        // Update covariance
        updated_covariance <= (16'd1 - kalman_gain) * predicted_covariance;
    end
end

endmodule