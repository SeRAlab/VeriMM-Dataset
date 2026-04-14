module gpio_controller (  
    input clk,  
    input reset,  
    input enable,  
    input [3:0] input_signal,  
    output reg [3:0] output_signal  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset) begin  
            output_signal <= 4'b0000;  
        end else if (enable) begin  
            output_signal <= input_signal;  
        end  
    end  
endmodule