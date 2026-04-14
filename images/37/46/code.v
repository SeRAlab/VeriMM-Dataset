module Adder16Bit (
    input [15:0] A,        // First 16-bit input
    input [15:0] B,        // Second 16-bit input
    output [15:0] Sum,     // 16-bit sum output
    output CarryOut        // Carry out output
);
    assign {CarryOut, Sum} = A + B; // Concatenate carry out with sum
endmodule