module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] process_noise,  
    input [15:0] measurement_noise,  
    output reg [15:0] state_estimate  
);  

    reg [15:0] state_predict;  
    reg [15:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            state_estimate <= 16'b0;  
        end else begin  
            // Prediction step  
            state_predict <= state_estimate;  

            // Kalman Gain calculation  
            kalman_gain <= state_predict + process_noise;  

            // Update step  
            state_estimate <= state_predict + kalman_gain * (measurement - state_predict) / (kalman_gain + measurement_noise);  
        end  
    end  
endmodule