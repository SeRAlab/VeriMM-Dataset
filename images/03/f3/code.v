module audio_mixer (
    input [7:0] audio1,
    input [7:0] audio2,
    input [7:0] audio3,
    output reg [7:0] mixed_audio
);
    always @(*) begin
        // Calculate the average of the three audio signals
        mixed_audio = (audio1 + audio2 + audio3) / 3;
    end
endmodule