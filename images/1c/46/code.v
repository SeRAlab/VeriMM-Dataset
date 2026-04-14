module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] process_noise,  
    input [15:0] measurement_noise,  
    output reg [15:0] estimated_position  
);  
    reg [15:0] kalman_gain;  
    reg [15:0] error_estimate;  
   
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimated_position <= 16'b0;  
            error_estimate <= 16'b0;  
            kalman_gain <= 16'b0;  
        end else begin  
            kalman_gain <= error_estimate / (error_estimate + measurement_noise);  
            estimated_position <= estimated_position + kalman_gain * (measurement - estimated_position);  
            error_estimate <= (1 - kalman_gain) * error_estimate + process_noise;  
        end  
    end  
endmodule