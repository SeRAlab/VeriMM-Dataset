module kalman_filter(clk, reset, measurement, estimate, error_estimate);  
    input clk;  
    input reset;  
    input [15:0] measurement;  
    output reg [15:0] estimate;  
    output reg [15:0] error_estimate;  

    reg [15:0] process_noise;  
    reg [15:0] measurement_noise;  
    reg [15:0] kalman_gain;  

    initial begin  
        estimate = 16'h0;  
        error_estimate = 16'h1000;  
        process_noise = 16'h1;  
        measurement_noise = 16'h1;  
    end  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 16'h0;  
            error_estimate <= 16'h1000;  
        end else begin  
            // Prediction step  
            error_estimate <= error_estimate + process_noise;  

            // Update step  
            kalman_gain <= error_estimate / (error_estimate + measurement_noise);  
            estimate <= estimate + kalman_gain * (measurement - estimate);  
            error_estimate <= (16'hFFFF - kalman_gain) * error_estimate;  
        end  
    end  
endmodule