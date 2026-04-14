module audio_mixer (
    input [7:0] audio1,
    input [7:0] audio2,
    output [7:0] mixed_audio
);
    assign mixed_audio = (audio1 + audio2 + 1) >> 1; // Simple average with rounding
endmodule