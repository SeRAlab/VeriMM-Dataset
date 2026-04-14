module audio_mixer (
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    output [7:0] audio_out
);
    assign audio_out = (audio_in1 + audio_in2) >> 1; // Average of two inputs
endmodule