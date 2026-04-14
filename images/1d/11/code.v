module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] process_noise,  
    input [15:0] measurement_noise,  
    output reg [15:0] estimate  
);  
    reg [15:0] estimate_prev;  
    reg [15:0] k_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 16'b0;  
            estimate_prev <= 16'b0;  
            k_gain <= 16'b0;  
        end else begin  
            // Calculate Kalman gain  
            k_gain <= (estimate_prev + process_noise) / (estimate_prev + process_noise + measurement_noise);  

            // Update estimate  
            estimate <= estimate_prev + k_gain * (measurement - estimate_prev);  
            estimate_prev <= estimate;  
        end  
    end  
endmodule