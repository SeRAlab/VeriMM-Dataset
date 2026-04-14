module Adder16Bit (
    input  [15:0] A,     // First 16-bit input
    input  [15:0] B,     // Second 16-bit input
    output [15:0] SUM,   // 16-bit sum output
    output COUT          // Carry-out output
);
    assign {COUT, SUM} = A + B; // Concatenate COUT with SUM
endmodule