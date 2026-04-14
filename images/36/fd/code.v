module echo_cancellation (  
    input clk,  
    input rst,  
    input [15:0] input_signal,  
    input [15:0] echo_signal,  
    output reg [15:0] cancelled_signal  
);  

    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            cancelled_signal <= 16'b0;  
        end else begin  
            cancelled_signal <= input_signal - echo_signal;  
        end  
    end  
endmodule