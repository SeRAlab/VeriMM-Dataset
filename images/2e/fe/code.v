module dynamic_range_compressor(  
    input [15:0] audio_in,  
    input [15:0] threshold,  
    input [7:0] compression_ratio,  
    output [15:0] audio_out  
);  
    wire [15:0] compressed_out;  
    assign compressed_out = (audio_in > threshold) ? (threshold + ((audio_in - threshold) >> compression_ratio)) : audio_in;  
    assign audio_out = compressed_out;  
endmodule