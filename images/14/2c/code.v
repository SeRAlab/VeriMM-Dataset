module four_bit_adder (
    input [3:0] A, // 4-bit input A
    input [3:0] B, // 4-bit input B
    output [4:0] SUM // 5-bit output SUM
);
    assign SUM = A + B; // Sum of A and B
endmodule