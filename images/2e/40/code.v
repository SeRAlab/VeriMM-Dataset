module audio_mixer (
    input [3:0] audio_in1,
    input [3:0] audio_in2,
    output reg [3:0] audio_out
);
    always @(*) begin
        audio_out = (audio_in1 + audio_in2) >> 1; // Calculate average
        if (audio_out > 4'b1111) // Saturation check
            audio_out = 4'b1111;
    end
endmodule