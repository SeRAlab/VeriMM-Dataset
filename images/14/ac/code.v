module gpio_controller (  
    input wire clk,  
    input wire enable,  
    input wire input_signal,  
    output reg output_signal  
);  

    always @(posedge clk) begin  
        if (enable) begin  
            output_signal <= input_signal;  
        end else begin  
            output_signal <= 1'b0;  
        end  
    end  
endmodule