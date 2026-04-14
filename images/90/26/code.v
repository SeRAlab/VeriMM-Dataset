module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire C1, C2, C3;
    wire S1, S2, S3, S4;
    
    // First bit addition
    xor(S1, A[0], B[0]);
    and(C1, A[0], B[0]);
    xor(S[0], S1, Cin);
    
    // Second bit addition
    xor(S2, A[1], B[1]);
    and(C2, A[1], B[1]);
    xor(S[1], S2, C1);
    
    // Third bit addition
    xor(S3, A[2], B[2]);
    and(C3, A[2], B[2]);
    xor(S[2], S3, C2);
    
    // Fourth bit addition
    xor(S4, A[3], B[3]);
    xor(S[3], S4, C3);
    and(Cout, C3, S4);
    
endmodule