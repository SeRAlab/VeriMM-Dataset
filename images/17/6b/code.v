module two_bit_adder (
    input [1:0] A,      // 2-bit input A
    input [1:0] B,      // 2-bit input B
    output [2:0] S,     // 3-bit sum output
    output Cout         // carry-out output
);
    assign {Cout, S} = A + B; // Concatenate Cout with S using addition
endmodule