module dynamic_range_compressor(  
    input [11:0] audio_in,  
    output reg [11:0] audio_out  
);  
    parameter THRESHOLD = 12'd2048;  
    parameter RATIO = 2;  

    always @(*) begin  
        if (audio_in > THRESHOLD)  
            audio_out = THRESHOLD + ((audio_in - THRESHOLD) / RATIO);  
        else  
            audio_out = audio_in;  
    end  
endmodule