module audio_compressor (
    input [4:0] audio_sample,
    output [3:0] compressed_audio
);
assign compressed_audio = audio_sample[4:1]; // Remove the LSB
endmodule