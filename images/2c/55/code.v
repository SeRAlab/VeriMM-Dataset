module kalman_filter(clk, reset, measurement, control, estimated_state, estimated_covariance);  
    input clk;  
    input reset;  
    input [15:0] measurement;  
    input [15:0] control;  
    output reg [15:0] estimated_state;  
    output reg [15:0] estimated_covariance;  
    
    // Kalman gain and noise parameters  
    parameter [15:0] PROCESS_NOISE = 16'h0001;  
    parameter [15:0] MEASUREMENT_NOISE = 16'h0002;  
    
    // Internal registers  
    reg [15:0] prediction;  
    reg [15:0] prediction_covariance;  
    reg [15:0] kalman_gain;  
    
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimated_state <= 16'h0000;  
            estimated_covariance <= 16'h0001;  
        end else begin  
            // Prediction step  
            prediction <= estimated_state + control;  
            prediction_covariance <= estimated_covariance + PROCESS_NOISE;  
            
            // Update step  
            kalman_gain <= prediction_covariance / (prediction_covariance + MEASUREMENT_NOISE);  
            estimated_state <= prediction + kalman_gain * (measurement - prediction);  
            estimated_covariance <= (16'hFFFF - kalman_gain) * prediction_covariance;  
        end  
    end  
endmodule