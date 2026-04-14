module KalmanFilter #(parameter WIDTH = 16) (  
    input clk,  
    input reset,  
    input signed [WIDTH-1:0] sensor1,  
    input signed [WIDTH-1:0] sensor2,  
    output reg signed [WIDTH-1:0] fused_output  
);  
    reg signed [WIDTH-1:0] estimate;  
    reg signed [WIDTH-1:0] error_covariance;  
    reg signed [WIDTH-1:0] kalman_gain;  
    reg signed [WIDTH-1:0] measurement;  
    reg signed [WIDTH-1:0] process_noise = 16'd1;  
    reg signed [WIDTH-1:0] measurement_noise = 16'd2;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 0;  
            error_covariance <= 16'd1;  
            fused_output <= 0;  
        end else begin  
            // Measurement update  
            measurement <= (sensor1 + sensor2) >> 1;  
            kalman_gain <= error_covariance / (error_covariance + measurement_noise);  
            estimate <= estimate + kalman_gain * (measurement - estimate);  
            error_covariance <= (16'd1 - kalman_gain) * error_covariance + process_noise;  
            fused_output <= estimate;  
        end  
    end  
endmodule