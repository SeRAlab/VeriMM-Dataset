module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement1,  
    input [15:0] measurement2,  
    output reg [15:0] estimated_position,  
    output reg [15:0] estimated_covariance  
);  
    reg [15:0] state_estimate;  
    reg [15:0] covariance_estimate;  
    reg [15:0] kalman_gain;  
    reg [15:0] process_noise;  
    reg [15:0] measurement_noise;  
    
    // Initialization  
    initial begin  
        state_estimate = 16'h0000;  
        covariance_estimate = 16'hFFFF;  
        process_noise = 16'h0001;  
        measurement_noise = 16'h0002;  
    end  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state_estimate <= 16'h0000;  
            covariance_estimate <= 16'hFFFF;  
        end else begin  
            // Prediction Step  
            covariance_estimate <= covariance_estimate + process_noise;  
          
            // Calculate Kalman Gain  
            kalman_gain <= covariance_estimate / (covariance_estimate + measurement_noise);  
          
            // Update Step  
            state_estimate <= state_estimate + kalman_gain * (measurement1 + measurement2 - state_estimate);  
            covariance_estimate <= (16'hFFFF - kalman_gain) * covariance_estimate;  
          
            // Output  
            estimated_position <= state_estimate;  
            estimated_covariance <= covariance_estimate;  
        end  
    end  
endmodule