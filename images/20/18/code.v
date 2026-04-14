module kalman_filter (  
    input clk,  
    input rst,  
    input [15:0] measurement,  
    input [15:0] control,  
    output reg [15:0] estimate,  
    output reg [15:0] error  
);  
    reg [15:0] process_noise = 16'h0001; // Example process noise  
    reg [15:0] measurement_noise = 16'h0005; // Example measurement noise  
    reg [15:0] kalman_gain;  
    reg [15:0] temp_estimate;  
    reg [15:0] temp_error;  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            estimate <= 16'h0000;  
            error <= 16'hFFFF;  
        end else begin  
            // Prediction Step  
            temp_estimate = estimate + control;  
            temp_error = error + process_noise;  

            // Update Step  
            kalman_gain = temp_error / (temp_error + measurement_noise);  
            estimate <= temp_estimate + (kalman_gain * (measurement - temp_estimate));  
            error <= (16'hFFFF - kalman_gain) * temp_error;  
        end  
    end  
endmodule