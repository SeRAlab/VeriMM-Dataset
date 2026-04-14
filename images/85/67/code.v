module adder_32bit(
    input [31:0] a,   // First 32-bit input signal.
    input [31:0] b,   // Second 32-bit input signal.
    input cin,        // Carry-in signal.

    output [31:0] sum, // 32-bit sum output.
    output cout       // Carry-out signal.
);

assign {cout, sum} = a + b + cin; // Add inputs and carry-in

endmodule