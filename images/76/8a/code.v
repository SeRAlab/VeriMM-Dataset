module top_module(A, B, Cin, S, Cout);input [3:0] A, B;
    input Cin;
    output [3:0] S;
    output Cout;
    
    wire c1, c2, c3;
    
    // 1-bit adders using built-in xor gates
    assign S[0] = A[0] ^ B[0] ^ Cin;
    assign c1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));
    
    assign S[1] = A[1] ^ B[1] ^ c1;
    assign c2 = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));

    assign S[2] = A[2] ^ B[2] ^ c2;
    assign c3 = (A[2] & B[2]) | (c2 & (A[2] ^ B[2]));

    assign S[3] = A[3] ^ B[3] ^ c3;
    assign Cout = (A[3] & B[3]) | (c3 & (A[3] ^ B[3]));
endmodule