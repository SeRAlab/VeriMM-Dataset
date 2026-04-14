module echo_cancellation(  
    input clk,  
    input rst,  
    input signed [15:0] input_signal,  
    input signed [15:0] reference_signal,  
    output reg signed [15:0] output_signal  
);  
    reg signed [15:0] echo_estimate;  
    reg signed [15:0] error;  
    reg signed [15:0] filter_coefficient;  
    parameter signed [15:0] mu = 16'sd1; // adaptation factor  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            echo_estimate <= 16'sd0;  
            filter_coefficient <= 16'sd1;  
            output_signal <= 16'sd0;  
        end else begin  
            echo_estimate <= filter_coefficient * reference_signal;  
            error <= input_signal - echo_estimate;  
            filter_coefficient <= filter_coefficient + (mu * error * reference_signal);  
            output_signal <= input_signal - echo_estimate;  
        end  
    end  
endmodule