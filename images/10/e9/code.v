module audio_mixer (
    input [15:0] audio_in1,
    input [15:0] audio_in2,
    input [15:0] audio_in3,
    input [15:0] audio_in4,
    output reg [15:0] audio_out
);

    always @(*) begin
        // Calculate the average of the four inputs
        audio_out = (audio_in1 + audio_in2 + audio_in3 + audio_in4) / 4;
        
        // Cap at maximum 16-bit value to avoid overflow
        if (audio_out > 16'hFFFF) begin
            audio_out = 16'hFFFF;
        end
    end
endmodule