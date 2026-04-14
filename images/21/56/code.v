module audio_mixer (
    input [3:0] audio_in1,
    input [3:0] audio_in2,
    output [3:0] audio_out
);
    assign audio_out = (audio_in1 + audio_in2) >> 1; // Average and round down
endmodule