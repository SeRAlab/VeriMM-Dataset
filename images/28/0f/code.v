module audio_gain_control(  
    input [15:0] audio_in,  
    input [2:0] gain,  
    output reg [15:0] audio_out  
);  
    always @(*) begin  
        // Multiply audio input by gain factor  
        audio_out = audio_in * {1'b0, gain};  
        // Clamp the output to 65535  
        if (audio_out > 16'hFFFF)  
            audio_out = 16'hFFFF;  
    end  
endmodule