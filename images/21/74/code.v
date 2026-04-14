module reset_controller(  
    input wire clk,  
    input wire reset,  
    input wire input_signal,  
    output reg output_signal  
);  
    always @(posedge clk or posedge reset) begin  
        if (reset)  
            output_signal <= 1'b0;  
        else  
            output_signal <= input_signal;  
    end  
endmodule