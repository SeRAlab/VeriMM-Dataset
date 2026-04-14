module adder_8bit(
    input [7:0] a,  // First 8-bit input operand.
    input [7:0] b,  // Second 8-bit input operand.
    input cin,      // Carry-in signal.

    output [7:0] sum, // 8-bit sum.
    output cout       // Carry-out signal.
);

assign {cout, sum} = a + b + cin; // Calculate sum and carry-out

endmodule