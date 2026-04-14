module kalman_filter(  
    input clk,  
    input rst,  
    input [15:0] measurement,  
    input [15:0] process_noise,  
    input [15:0] measurement_noise,  
    output reg [15:0] state_estimate  
);  

    reg [15:0] error_covariance;  
    reg [15:0] kalman_gain;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            state_estimate <= 16'b0;  
            error_covariance <= 16'b100;  
        end else begin  
            // Update Kalman Gain  
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);  

            // Update State Estimate  
            state_estimate <= state_estimate + kalman_gain * (measurement - state_estimate);  

            // Update Error Covariance  
            error_covariance <= (16'b1 - kalman_gain) * error_covariance + process_noise;  
        end  
    end  
endmodule