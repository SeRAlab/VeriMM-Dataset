module audio_mixer(  
    input [4:0] audio1,  
    input [4:0] audio2,  
    output [4:0] mixed_audio  
);  
    assign mixed_audio = (audio1 + audio2) / 2;  
endmodule