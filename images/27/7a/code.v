module audio_compressor (
    input [15:0] audio_sample,
    output reg [15:0] compressed_sample
);
    reg [7:0] count;
    reg [15:0] last_sample;
    integer i;

    always @(*) begin
        count = 1;
        last_sample = audio_sample;
        compressed_sample = 16'b0;

        for (i = 1; i < 16; i = i + 1) begin
            if (audio_sample[i] == audio_sample[i - 1]) begin
                count = count + 1;
            end else begin
                compressed_sample = {count, last_sample};
                last_sample = audio_sample[i];
                count = 1;
            end
        end
        
        compressed_sample = {count, last_sample}; // Output the last segment
    end
endmodule