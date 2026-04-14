module audio_mixer(  
    input clk,  
    input [7:0] audio1,  
    input [7:0] audio2,  
    output reg [7:0] mixed_audio  
);  
    always @(posedge clk) begin  
        mixed_audio <= (audio1 + audio2 > 255) ? 8'd255 : audio1 + audio2;  
    end  
endmodule