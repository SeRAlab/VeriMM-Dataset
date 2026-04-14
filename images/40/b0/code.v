module kalman_filter(
    input clk,
    input reset,
    input [15:0] measurement,
    input [15:0] process_noise_cov,
    input [15:0] measurement_noise_cov,
    input [15:0] prev_estimate,
    output reg [15:0] state_estimate
);
    reg [15:0] kalman_gain;
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            state_estimate <= 16'b0;
            kalman_gain <= 16'b0;
        end else begin
            // Kalman Gain Calculation
            kalman_gain <= (prev_estimate + process_noise_cov) / 
                           ((prev_estimate + process_noise_cov) + measurement_noise_cov);
            // State Estimate Update
            state_estimate <= prev_estimate + 
                              (kalman_gain * (measurement - prev_estimate));
        end
    end
endmodule