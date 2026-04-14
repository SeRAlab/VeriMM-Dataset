module audio_compressor (
    input [4:0] audio_in,
    output [4:0] audio_out
);
    assign audio_out = audio_in >> 1; // Halve the audio level using right shift
endmodule