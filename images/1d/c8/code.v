module kalman_filter(  
    input clk,  
    input reset,  
    input signed [15:0] measurement,  
    input signed [15:0] predicted_state,  
    input signed [15:0] predicted_covariance,  
    output reg signed [15:0] updated_state,  
    output reg signed [15:0] updated_covariance  
);  
    reg signed [15:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            updated_state <= 0;  
            updated_covariance <= 0;  
        end else begin  
            kalman_gain <= predicted_covariance / (predicted_covariance + 1);  
            updated_state <= predicted_state + (kalman_gain * (measurement - predicted_state));  
            updated_covariance <= (1 - kalman_gain) * predicted_covariance;  
        end  
    end  
endmodule