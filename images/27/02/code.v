module audio_mixer (
    input [3:0] audio_in1,
    input [3:0] audio_in2,
    input [3:0] audio_in3,
    input [3:0] audio_in4,
    output reg [3:0] audio_out
);
    always @(*) begin
        audio_out = (audio_in1 + audio_in2 + audio_in3 + audio_in4) >> 2; // Average the inputs
    end
endmodule