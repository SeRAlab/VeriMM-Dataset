module audio_mixer(  
    input [15:0] audio_in1,  
    input [15:0] audio_in2,  
    input sel,  
    output reg [15:0] audio_out  
);  

    always @(*) begin  
        if (audio_in1 !== 16'b0 && audio_in2 !== 16'b0)  
            audio_out = (audio_in1 + audio_in2) >> 1; // Average both signals  
        else if (sel)  
            audio_out = audio_in2;  
        else  
            audio_out = audio_in1;  
    end  
endmodule