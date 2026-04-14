module kalman_filter(clk, reset, measurement, estimated_position, estimated_covariance);  
    input clk;  
    input reset;  
    input [15:0] measurement;  
    output reg [15:0] estimated_position;  
    output reg [15:0] estimated_covariance;  

    reg [15:0] process_noise_covariance = 16'h0001;  
    reg [15:0] measurement_noise_covariance = 16'h0002;  
    reg [15:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimated_position <= 16'h0000;  
            estimated_covariance <= 16'h0001;  
        end else begin  
            // Prediction step  
            estimated_covariance <= estimated_covariance + process_noise_covariance;  
            // Update step  
            kalman_gain <= estimated_covariance / (estimated_covariance + measurement_noise_covariance);  
            estimated_position <= estimated_position + kalman_gain * (measurement - estimated_position);  
            estimated_covariance <= (16'h0001 - kalman_gain) * estimated_covariance;  
        end  
    end  
endmodule