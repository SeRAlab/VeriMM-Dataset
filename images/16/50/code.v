module kalman_filter #(parameter DATA_WIDTH = 16) (  
    input clk,  
    input reset,  
    input [DATA_WIDTH-1:0] measurement,  
    output reg [DATA_WIDTH-1:0] position_estimate  
);  

    reg [DATA_WIDTH-1:0] previous_estimate;  
    reg [DATA_WIDTH-1:0] kalman_gain;  
    reg [DATA_WIDTH-1:0] process_variance = 16'h0001;  
    reg [DATA_WIDTH-1:0] measurement_variance = 16'h0004;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            position_estimate <= 0;  
            previous_estimate <= 0;  
            kalman_gain <= 0;  
        end else begin  
            kalman_gain <= process_variance / (process_variance + measurement_variance);  
            position_estimate <= previous_estimate + kalman_gain * (measurement - previous_estimate);  
            previous_estimate <= position_estimate;  
            process_variance <= (1 - kalman_gain) * process_variance;  
        end  
    end  
endmodule