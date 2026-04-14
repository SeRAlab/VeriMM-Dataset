module audio_mixer (
    input [3:0] A,
    input [3:0] B,
    output [3:0] Y
);
    assign Y = (A + B) >> 1; // Average of A and B, shifted right by 1 for rounding
endmodule