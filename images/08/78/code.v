module audio_mixer(
    input [3:0] audio_sample1,
    input [3:0] audio_sample2,
    output reg [3:0] mixed_audio
);
    
    always @(*) begin
        mixed_audio = (audio_sample1 + audio_sample2) / 2;

        if (mixed_audio > 4'b1111) begin
            mixed_audio = 4'b1111; // Clip to maximum 4-bit value if exceeded
        end
    end
endmodule