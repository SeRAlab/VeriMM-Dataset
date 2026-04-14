module kalman_filter (
    input clk,
    input reset,
    input [15:0] measurement,
    input update,
    output reg [15:0] estimate
);
    reg [15:0] error_covariance;
    reg [15:0] kalman_gain;

    initial begin
        estimate = 16'b0;
        error_covariance = 16'b1000; // Initial error covariance
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            estimate <= 16'b0;
            error_covariance <= 16'b1000;
        end else if (update) begin
            // Update Kalman gain
            kalman_gain <= error_covariance / (error_covariance + 16'b100); // Measurement noise

            // Update estimate
            estimate <= estimate + (kalman_gain * (measurement - estimate));

            // Update error covariance
            error_covariance <= (16'b1111 - kalman_gain) * error_covariance;
        end
    end
endmodule