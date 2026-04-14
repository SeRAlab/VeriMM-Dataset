module audio_compressor (
    input [3:0] sample_in,
    output [1:0] sample_out
);
    assign sample_out = sample_in[3:2]; // Compress by taking the most significant 2 bits
endmodule