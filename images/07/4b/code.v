module dynamic_range_compressor(  
    input signed [4:0] in_signal,  
    output signed [4:0] out_signal  
);  
    assign out_signal = (in_signal < -2) ? -2 :  
                        (in_signal > 2) ? 2 :  
                        in_signal;  
endmodule