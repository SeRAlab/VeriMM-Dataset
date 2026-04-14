module audio_mixer (
    input clk,
    input [3:0] audio_in1,
    input [3:0] audio_in2,
    output reg [3:0] mixed_audio
);
    
    always @(posedge clk) begin
        mixed_audio <= (audio_in1 + audio_in2 > 15) ? 15 : (audio_in1 + audio_in2);
    end
    
endmodule