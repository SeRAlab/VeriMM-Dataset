module audio_mixer (
    input [3:0] A,
    input [3:0] B,
    output [3:0] O
);
    wire [4:0] sum; // 5 bits to hold the sum
    assign sum = A + B;
    assign O = sum[4:1]; // Average with rounding down
endmodule