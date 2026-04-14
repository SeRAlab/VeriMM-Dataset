module multiplier_2bit (
    input [1:0] A, // 2-bit input A
    input [1:0] B, // 2-bit input B
    output [3:0] P // 4-bit output P
);
    assign P = A * B; // Multiply A and B
endmodule