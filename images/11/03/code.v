module KalmanFilter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] control_input,  
    output reg [15:0] estimated_position  
);  
    // State variables  
    reg [15:0] position_estimate;  
    reg [15:0] error_covariance;  
    reg [15:0] kalman_gain;  

    // Kalman filter parameters  
    parameter [15:0] process_noise = 16'h0001;  
    parameter [15:0] measurement_noise = 16'h0002;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            position_estimate <= 16'h0000;  
            error_covariance <= 16'h0000;  
            estimated_position <= 16'h0000;  
        end else begin  
            // Prediction step  
            position_estimate <= position_estimate + control_input;  
            error_covariance <= error_covariance + process_noise;  

            // Update step  
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);  
            position_estimate <= position_estimate + (kalman_gain * (measurement - position_estimate));  
            error_covariance <= (16'hFFFF - kalman_gain) * error_covariance;  

            estimated_position <= position_estimate;  
        end  
    end  
endmodule