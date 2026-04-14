module audio_mixer (
    input [7:0] A,
    input [7:0] B,
    input [7:0] C,
    input [7:0] D,
    output [7:0] Y
);
    assign Y = (A + B + C + D) >> 2; // Average the inputs
endmodule