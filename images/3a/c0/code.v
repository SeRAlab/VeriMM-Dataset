module kalman_filter (
    input clk,
    input reset,
    input [15:0] control_input,
    input [15:0] measurement_input,
    output reg [15:0] estimated_state,
    output reg [15:0] error_covariance
);
    reg [15:0] state_pred;
    reg [15:0] cov_pred;
    reg [15:0] kalman_gain;

    // Kalman filter parameters
    parameter [15:0] process_noise = 16'h0001; // Q
    parameter [15:0] measurement_noise = 16'h0004; // R
    parameter [15:0] identity = 16'h0001;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimated_state <= 16'h0000;
            error_covariance <= 16'h0001;
        end else begin
            // Prediction step
            state_pred <= estimated_state + control_input;
            cov_pred <= error_covariance + process_noise;

            // Update step
            kalman_gain <= cov_pred / (cov_pred + measurement_noise);
            estimated_state <= state_pred + kalman_gain * (measurement_input - state_pred);
            error_covariance <= (identity - kalman_gain) * cov_pred;
        end
    end
endmodule