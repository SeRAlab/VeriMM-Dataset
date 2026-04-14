module echo_canceller(  
    input clk,  
    input rst,  
    input signed [15:0] input_signal,  
    input signed [15:0] echo_signal,  
    output signed [15:0] output_signal  
);  
    reg signed [15:0] delayed_signal [1:0];  
    always @(posedge clk or posedge rst) begin  
        if (rst) begin  
            delayed_signal[0] <= 16'b0;  
            delayed_signal[1] <= 16'b0;  
        end else begin  
            delayed_signal[0] <= input_signal;  
            delayed_signal[1] <= delayed_signal[0];  
        end  
    end  
    assign output_signal = input_signal - delayed_signal[1];  
endmodule