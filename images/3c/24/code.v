module kalman_filter (
    input clk,
    input rst,
    input [15:0] measurement,
    input [15:0] prev_estimate,
    input [15:0] process_noise_cov,
    output reg [15:0] updated_estimate,
    output reg [15:0] kalman_gain
);

    reg [15:0] error_cov;
    reg [15:0] kalman_gain_temp;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            updated_estimate <= 0;
            kalman_gain <= 0;
            error_cov <= 16'hFFFF; // Initial high error covariance
        end else begin
            // Calculate Kalman Gain
            kalman_gain_temp = error_cov / (error_cov + process_noise_cov);
            kalman_gain <= kalman_gain_temp;

            // Update the estimate
            updated_estimate <= prev_estimate + (kalman_gain_temp * (measurement - prev_estimate));

            // Update the error covariance
            error_cov <= (16'hFFFF - kalman_gain_temp) * error_cov;
        end
    end
endmodule