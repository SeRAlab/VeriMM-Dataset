module audio_mixer (  
    input [15:0] audio1,  
    input [15:0] audio2,  
    output reg [15:0] mixed_audio  
);  
    always @(*) begin  
        mixed_audio = (audio1 + audio2) >> 1; // Calculate the average  
        if (mixed_audio > 16'hFFFF) begin  
            mixed_audio = 16'hFFFF; // Saturate the output  
        end  
    end  
endmodule