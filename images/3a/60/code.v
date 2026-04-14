module audio_mixer (
    input [7:0] audio1,
    input [7:0] audio2,
    output [7:0] mixed_audio
);
    assign mixed_audio = (audio1 + audio2) >> 1; // Average of audio1 and audio2
endmodule