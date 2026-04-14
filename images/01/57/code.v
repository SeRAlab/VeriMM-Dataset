module kalman_filter(  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] estimated_position,  
    output reg [15:0] new_estimated_position,  
    output reg [15:0] error_covariance  
);  

    parameter [15:0] Q = 16'h0001; // Process noise covariance  
    parameter [15:0] R = 16'h0002; // Measurement noise covariance  
    reg [15:0] K; // Kalman gain  
    reg [15:0] temp_estimate;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_estimated_position <= 16'h0000;  
            error_covariance <= 16'hFFFF;  
        end else begin  
            // Predict step  
            temp_estimate <= estimated_position;  
            error_covariance <= error_covariance + Q;  

            // Calculate Kalman Gain  
            K <= error_covariance / (error_covariance + R);  

            // Update step  
            new_estimated_position <= temp_estimate + K * (measurement - temp_estimate);  
            error_covariance <= (16'hFFFF - K) * error_covariance;  
        end  
    end  
endmodule