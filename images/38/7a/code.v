module audio_mixer (
    input [7:0] A, 
    input [7:0] B, 
    input [7:0] C, 
    output [7:0] Y
);
    wire [9:0] sum; // to hold the sum of inputs
    assign sum = A + B + C;
    assign Y = (sum > 255) ? 8'd255 : sum / 3; // average and saturation
endmodule