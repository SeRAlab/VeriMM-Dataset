module kalman_filter(  
    input clk,  
    input reset,  
    input [15:0] sensor1_meas,  
    input [15:0] sensor2_meas,  
    output reg [15:0] fused_estimate  
);  
    reg [15:0] estimate;  
    reg [15:0] covariance;  
    reg [15:0] kalman_gain;  
    reg [15:0] process_noise;  
    reg [15:0] measurement_noise;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 0;  
            covariance <= 16'hFFFF; // Initial high uncertainty  
            process_noise <= 16'h0001;  
            measurement_noise <= 16'h0002;  
        end else begin  
            // Prediction step  
            covariance <= covariance + process_noise;  
            // Update step  
            kalman_gain <= covariance / (covariance + measurement_noise);  
            estimate <= estimate + kalman_gain * (sensor1_meas + sensor2_meas - estimate);  
            covariance <= (16'hFFFF - kalman_gain) * covariance;  
            fused_estimate <= estimate;  
        end  
    end  
endmodule