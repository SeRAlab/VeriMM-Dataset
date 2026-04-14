module kalman_filter(  
    input clk,  
    input reset,  
    input [15:0] sensor1_measurement,  
    input [15:0] sensor2_measurement,  
    output reg [15:0] estimated_position,  
    output reg [15:0] estimated_velocity  
);  
    // Kalman filter variables  
    reg [15:0] position_estimate;  
    reg [15:0] velocity_estimate;  
    reg [15:0] error_estimate;  
    reg [15:0] kalman_gain;  

    // Constants for the Kalman filter  
    parameter [15:0] process_noise = 16'd1;  
    parameter [15:0] measurement_noise = 16'd4;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            position_estimate <= 16'd0;  
            velocity_estimate <= 16'd0;  
            error_estimate <= 16'd10;  
        end else begin  
            // Prediction step  
            position_estimate <= position_estimate + velocity_estimate;  
            error_estimate <= error_estimate + process_noise;  

            // Compute Kalman Gain  
            kalman_gain <= error_estimate / (error_estimate + measurement_noise);  

            // Update step  
            position_estimate <= position_estimate + kalman_gain * (sensor1_measurement + sensor2_measurement) / 2 - position_estimate;  
            error_estimate <= (1 - kalman_gain) * error_estimate;  

            estimated_position <= position_estimate;  
            estimated_velocity <= velocity_estimate;  
        end  
    end  
endmodule