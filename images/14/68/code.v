module echo_cancellation(  
    input clk,  
    input reset,  
    input [7:0] echo_signal,  
    input [7:0] input_signal,  
    output reg [7:0] clean_signal  
);  
    reg [7:0] delayed_echo;  

    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            clean_signal <= 8'b0;  
            delayed_echo <= 8'b0;  
        end else begin  
            clean_signal <= input_signal - delayed_echo;  
            delayed_echo <= echo_signal;  
        end  
    end  
endmodule