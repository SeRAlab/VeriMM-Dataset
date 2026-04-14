module dynamic_range_compressor(  
    input [3:0] in_signal,  
    input [3:0] threshold,  
    output reg [3:0] out_signal  
);  
    always @(*) begin  
        if (in_signal > threshold)  
            out_signal = threshold + (in_signal - threshold) >> 1;  
        else  
            out_signal = in_signal;  
    end  
endmodule