module audio_mixer (
    input [7:0] audio1,
    input [7:0] audio2,
    input [7:0] audio3,
    output [7:0] mixed_audio
);
    wire [9:0] sum; // Use a larger bit-width to avoid overflow
    assign sum = audio1 + audio2 + audio3; // Sum the audio inputs
    assign mixed_audio = sum / 3; // Average the sum (integer division)
endmodule