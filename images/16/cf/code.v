module ripple_carry_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);
    wire C1, C2, C3;

    // Full adder logic
    assign Sum[0] = A[0] ^ B[0] ^ Cin;
    assign C1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));

    assign Sum[1] = A[1] ^ B[1] ^ C1;
    assign C2 = (A[1] & B[1]) | (C1 & (A[1] ^ B[1]));

    assign Sum[2] = A[2] ^ B[2] ^ C2;
    assign C3 = (A[2] & B[2]) | (C2 & (A[2] ^ B[2]));

    assign Sum[3] = A[3] ^ B[3] ^ C3;
    assign Cout = (A[3] & B[3]) | (C3 & (A[3] ^ B[3]));
endmodule