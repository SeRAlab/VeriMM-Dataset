module audio_mixer(  
    input [4:0] audio_in1,  
    input [4:0] audio_in2,  
    output [4:0] mixed_audio  
);  
    assign mixed_audio = audio_in1 & audio_in2;  
endmodule