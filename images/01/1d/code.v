module ripple_carry_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [4:0] Sum,
    output Cout
);
    wire [3:0] carry;

    // Full Adder logic for each bit
    assign Sum[0] = A[0] ^ B[0] ^ Cin;
    assign carry[0] = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));

    assign Sum[1] = A[1] ^ B[1] ^ carry[0];
    assign carry[1] = (A[1] & B[1]) | (carry[0] & (A[1] ^ B[1]));

    assign Sum[2] = A[2] ^ B[2] ^ carry[1];
    assign carry[2] = (A[2] & B[2]) | (carry[1] & (A[2] ^ B[2]));

    assign Sum[3] = A[3] ^ B[3] ^ carry[2];
    assign Cout = (A[3] & B[3]) | (carry[2] & (A[3] ^ B[3]));

    assign Sum[4] = Cout; // Carry out
endmodule