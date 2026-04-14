module audio_mixer (
    input [3:0] A, 
    input [3:0] B, 
    output [3:0] M
);
    assign M = (A + B) >> 1; // Calculate the average of A and B
endmodule