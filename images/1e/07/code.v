module audio_mixer (  
    input [7:0] audio1,  
    input [7:0] audio2,  
    input mute,  
    output reg [7:0] output_audio  
);  
    always @(audio1, audio2, mute) begin  
        if (mute)  
            output_audio <= 8'b00000000;  
        else  
            output_audio <= (audio1 + audio2);  
    end  
endmodule