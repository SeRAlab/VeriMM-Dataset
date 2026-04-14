module audio_compressor(  
    input [15:0] audio_sample,  
    output [15:0] compressed_sample  
);  
    assign compressed_sample = {audio_sample[15:8], 8'b0};  
endmodule