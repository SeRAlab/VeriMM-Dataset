module echo_cancellation (  
    input clk,  
    input [15:0] input_signal,  
    input [15:0] echo_signal,  
    output reg [15:0] output_signal  
);  
    always @(posedge clk) begin  
        output_signal <= input_signal - echo_signal;  
    end  
endmodule