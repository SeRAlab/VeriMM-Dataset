module kalman_filter (  
    input clk,  
    input reset,  
    input [15:0] measurement,  
    input [15:0] control,  
    output reg [15:0] estimate  
);  

    reg [15:0] estimate_prev;  
    reg [15:0] kalman_gain;  
    wire [15:0] process_noise = 16'h0001;  
    wire [15:0] measurement_noise = 16'h0002;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            estimate <= 16'h0000;  
            estimate_prev <= 16'h0000;  
        end else begin  
            // Prediction step  
            estimate_prev <= estimate + control;  

            // Update step  
            kalman_gain <= estimate_prev / (estimate_prev + measurement_noise);  
            estimate <= estimate_prev + kalman_gain * (measurement - estimate_prev);  
        end  
    end  
endmodule