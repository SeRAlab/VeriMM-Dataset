module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    output reg [15:0] estimate_position  
);  
    reg [15:0] estimate_velocity;  
    reg [15:0] error_covariance;  
    reg [15:0] kalman_gain;  
    reg [15:0] process_noise;  
    reg [15:0] measurement_noise;  

    initial begin  
        estimate_position = 16'b0;  
        estimate_velocity = 16'b0;  
        error_covariance = 16'b1000;  
        process_noise = 16'b10;  
        measurement_noise = 16'b100;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate_position <= 16'b0;  
            estimate_velocity <= 16'b0;  
            error_covariance <= 16'b1000;  
        end else begin  
            // Prediction step  
            estimate_position <= estimate_position + estimate_velocity;  
            error_covariance <= error_covariance + process_noise;  

            // Update step  
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);  
            estimate_position <= estimate_position + kalman_gain * (measurement - estimate_position);  
            error_covariance <= (16'b1 - kalman_gain) * error_covariance;  
        end  
    end  
endmodule