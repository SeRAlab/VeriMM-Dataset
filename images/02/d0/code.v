module echo_cancellation (  
    input clk,  
    input rst,  
    input signed [15:0] input_signal,  
    input signed [15:0] echo_signal,  
    output reg signed [15:0] output_signal  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            output_signal <= 16'sd0;  
        end else begin  
            output_signal <= input_signal - echo_signal;  
        end  
    end  
endmodule