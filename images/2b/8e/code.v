module multiplier_2bit (
    input [1:0] A,
    input [1:0] B,
    output [3:0] Y
);
    assign Y = A * B; // Multiplying the two 2-bit numbers
endmodule