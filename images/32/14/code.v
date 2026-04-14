module kalman_filter (
    input clk,
    input reset,
    input [15:0] measured_position,
    input [15:0] estimated_position,
    output reg [15:0] new_estimated_position
);
    reg [15:0] kalman_gain;
    reg [15:0] error_covariance;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            new_estimated_position <= 16'b0;
            kalman_gain <= 16'b1; // Initial Kalman gain
            error_covariance <= 16'b1; // Initial error covariance
        end else begin
            // Update the Kalman gain
            kalman_gain <= error_covariance / (error_covariance + 16'b1); // Assuming measurement noise = 1
            
            // Update the estimated position
            new_estimated_position <= estimated_position + kalman_gain * (measured_position - estimated_position);
            
            // Update error covariance
            error_covariance <= (16'b1 - kalman_gain) * error_covariance;
        end
    end
endmodule