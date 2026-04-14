module two_bit_adder (
    input [1:0] A,     // 2-bit input A
    input [1:0] B,     // 2-bit input B
    output [2:0] SUM   // 3-bit output SUM
);
    assign SUM = A + B; // Sum of A and B
endmodule