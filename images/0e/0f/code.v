module kalman_filter (
    input clk,
    input rst,
    input [15:0] pos1,
    input [15:0] pos2,
    output reg [15:0] est_pos,
    output reg [15:0] error_cov
);

    reg [15:0] k_gain; // Kalman gain
    reg [15:0] measurement; // average of the two sensor measurements

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            est_pos <= 16'b0;
            error_cov <= 16'b0;
            k_gain <= 16'b0;
        end else begin
            // Simple average of the two positions as measurement
            measurement <= (pos1 + pos2) >> 1;

            // Update Kalman gain (simplified)
            k_gain <= error_cov / (error_cov + 16'd1); // assuming measurement noise of 1

            // Update estimate
            est_pos <= est_pos + k_gain * (measurement - est_pos);
            // Update error covariance
            error_cov <= (16'd1 - k_gain) * error_cov;
        end
    end

endmodule