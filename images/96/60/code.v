module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire C1, C2, C3;
    
    // Calculation of the sum bits
    xor(S[0], A[0], B[0], Cin);
    xor(S[1], A[1], B[1], C1);
    xor(S[2], A[2], B[2], C2);
    xor(S[3], A[3], B[3], C3);
    
    // Calculation of the carry out bit
    or(Cout, C1, C2, C3);

endmodule