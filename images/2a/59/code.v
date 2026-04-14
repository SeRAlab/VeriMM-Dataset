module kalman_filter(
    input wire clk,
    input wire reset,
    input wire [15:0] previous_estimate,
    input wire [15:0] measurement,
    input wire [15:0] process_noise,
    input wire [15:0] measurement_noise,
    output reg [15:0] updated_estimate
);
    reg [15:0] kalman_gain;
    reg [15:0] estimate_covariance;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            updated_estimate <= 16'b0;
            estimate_covariance <= 16'b0;
            kalman_gain <= 16'b0;
        end else begin
            // Update estimate covariance
            estimate_covariance <= estimate_covariance + process_noise;
            
            // Calculate Kalman gain
            kalman_gain <= estimate_covariance / (estimate_covariance + measurement_noise);
            
            // Update the estimate
            updated_estimate <= previous_estimate + (kalman_gain * (measurement - previous_estimate));
        end
    end
endmodule