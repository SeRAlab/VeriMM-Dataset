module audio_mixer (
    input [7:0] audio_in1,
    input [7:0] audio_in2,
    input [1:0] control,
    output reg [7:0] audio_out
);
    always @(*) begin
        case (control)
            2'b00: audio_out = audio_in1;                 // Output audio_in1
            2'b01: audio_out = audio_in2;                 // Output audio_in2
            2'b10: audio_out = (audio_in1 + audio_in2) >> 1; // Average of audio_in1 and audio_in2
            2'b11: audio_out = (audio_in1 > audio_in2) ? audio_in1 : audio_in2; // Max of audio_in1 and audio_in2
            default: audio_out = 8'b00000000;             // Default case
        endcase
    end
endmodule