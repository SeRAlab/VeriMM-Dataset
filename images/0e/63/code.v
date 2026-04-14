module audio_compression (  
    input [4:0] audio_in,  
    output [2:0] audio_out  
);  
    assign audio_out = audio_in[4:2];  
endmodule