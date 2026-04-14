module dynamic_range_compressor(  
    input clk,  
    input [15:0] input_signal,  
    input [15:0] threshold,  
    input [3:0] compression_ratio,  
    output reg [15:0] output_signal  
);  
    always @(posedge clk) begin  
        if (input_signal > threshold)  
            output_signal <= (input_signal - threshold) >> compression_ratio;  
        else  
            output_signal <= input_signal;  
    end  
endmodule