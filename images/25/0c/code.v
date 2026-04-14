module eight_bit_adder (
    input [7:0] A,       // First 8-bit input
    input [7:0] B,       // Second 8-bit input
    output [7:0] SUM,    // 8-bit sum output
    output COUT          // Carry out output
);
    assign {COUT, SUM} = A + B; // Perform addition
endmodule