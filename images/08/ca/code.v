module audio_mixer (
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    input [7:0] audio_in3,
    input [7:0] audio_in4,
    output [7:0] mixed_audio
);
    assign mixed_audio = (audio_in1 + audio_in2 + audio_in3 + audio_in4) >> 2; // Average calculation
endmodule