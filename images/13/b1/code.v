module audio_mixer (
    input [15:0] A,  // 16-bit audio signal A
    input [15:0] B,  // 16-bit audio signal B
    input S,         // Select signal
    output [15:0] Y  // Output audio signal
);
    assign Y = (S == 1'b0) ? A : B; // Select A or B based on S
endmodule