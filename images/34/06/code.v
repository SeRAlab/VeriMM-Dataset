module dynamic_range_compressor(  
    input signed [4:0] audio_in,  
    input signed [4:0] threshold,  
    output reg signed [4:0] audio_out  
);  
    always @(*) begin  
        if (audio_in > threshold)  
            audio_out = threshold;  
        else  
            audio_out = audio_in;  
    end  
endmodule