module audio_mixer (
    input [7:0] audio_sample1,
    input [7:0] audio_sample2,
    output [7:0] mixed_audio
);
    assign mixed_audio = (audio_sample1 + audio_sample2 + 1) >> 1; // Averaging and rounding
endmodule