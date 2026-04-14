module echo_cancellation(  
    input clk,  
    input rst,  
    input signed [15:0] original_signal,  
    input signed [15:0] echo_signal,  
    output reg signed [15:0] cleaned_signal  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst)  
            cleaned_signal <= 16'b0;  
        else  
            cleaned_signal <= original_signal - echo_signal;  
    end  
endmodule