module dynamic_range_compressor (
    input [15:0] audio_in, // 16-bit audio input
    output [15:0] audio_out // 16-bit audio output
);
    parameter THRESHOLD = 16'h0C00; // Define threshold
    parameter GAIN = 16'h0A00; // Define gain (in fixed-point representation)

    assign audio_out = (audio_in > THRESHOLD) ? (audio_in - GAIN) : audio_in;
endmodule