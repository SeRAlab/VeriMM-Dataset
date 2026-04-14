module ripple_carry_adder (
    input [3:0] A,    // First 4-bit input
    input [3:0] B,    // Second 4-bit input
    input Cin,        // Carry-in
    output [3:0] Sum, // 4-bit sum output
    output Cout       // Carry-out
);
    wire C1, C2, C3; // Internal carry wires

    // Full Adder for bit 0
    assign Sum[0] = A[0] ^ B[0] ^ Cin;
    assign C1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));

    // Full Adder for bit 1
    assign Sum[1] = A[1] ^ B[1] ^ C1;
    assign C2 = (A[1] & B[1]) | (C1 & (A[1] ^ B[1]));

    // Full Adder for bit 2
    assign Sum[2] = A[2] ^ B[2] ^ C2;
    assign C3 = (A[2] & B[2]) | (C2 & (A[2] ^ B[2]));

    // Full Adder for bit 3
    assign Sum[3] = A[3] ^ B[3] ^ C3;
    assign Cout = (A[3] & B[3]) | (C3 & (A[3] ^ B[3]));

endmodule