module audio_compressor(
    input [15:0] audio_sample,
    output reg [7:0] compressed_output
);
    always @(*) begin
        if (audio_sample > 16'd128) begin
            compressed_output = audio_sample[15:8]; // Take the high byte
        end else begin
            compressed_output = audio_sample[7:0]; // Take the low byte
        end
    end
endmodule