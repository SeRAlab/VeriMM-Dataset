module kalman_filter (  
    input wire clk,  
    input wire reset,  
    input wire signed [15:0] measurement,  
    input wire signed [15:0] previous_estimate,  
    output reg signed [15:0] new_estimate  
);  
    parameter signed [15:0] process_noise = 16'h1;  
    parameter signed [15:0] measurement_noise = 16'h2;  
    reg signed [15:0] kalman_gain;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            new_estimate <= 16'h0;  
        end else begin  
            kalman_gain <= process_noise / (process_noise + measurement_noise);  
            new_estimate <= previous_estimate + kalman_gain * (measurement - previous_estimate);  
        end  
    end  
endmodule