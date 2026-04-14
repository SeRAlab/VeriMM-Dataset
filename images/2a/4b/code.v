module kalman_filter (
    input wire clk,
    input wire rst,
    input wire [15:0] measurement,
    input wire [15:0] control,
    output reg [15:0] state_estimate
);
    reg [15:0] process_noise = 16'h0001; // Process noise covariance
    reg [15:0] measurement_noise = 16'h0002; // Measurement noise covariance
    reg [15:0] error_covariance = 16'h0004; // Initial error covariance
    reg [15:0] kalman_gain;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            state_estimate <= 16'h0000;
            error_covariance <= 16'h0004;
        end else begin
            // Predict phase
            state_estimate <= state_estimate + control; // Update state with control input
            error_covariance <= error_covariance + process_noise; // Update error covariance

            // Update phase
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);
            state_estimate <= state_estimate + kalman_gain * (measurement - state_estimate);
            error_covariance <= (16'h0001 - kalman_gain) * error_covariance; // Update error covariance
        end
    end
endmodule