module top_module(
    input [7:0] A,
    input [2:0] S,
    output X
);wire w0, w1, w2, w3, w4, w5, w6;
    assign w0 = S[2] & S[1] & S[0] & A[7];
    assign w1 = S[2] & S[1] & ~S[0] & A[6];
    assign w2 = S[2] & ~S[1] & S[0] & A[5];
    assign w3 = S[2] & ~S[1] & ~S[0] & A[4];
    assign w4 = ~S[2] & S[1] & S[0] & A[3];
    assign w5 = ~S[2] & S[1] & ~S[0] & A[2];
    assign w6 = ~S[2] & ~S[1] & S[0] & A[1];
    assign X = ~S[2] & ~S[1] & ~S[0] & A[0]
             | ~S[2] & ~S[1] & S[0] & A[1]
             | ~S[2] & S[1] & ~S[0] & A[2]
             | ~S[2] & S[1] & S[0] & A[3]
             | S[2] & ~S[1] & ~S[0] & A[4]
             | S[2] & ~S[1] & S[0] & A[5]
             | S[2] & S[1] & ~S[0] & A[6]
             | S[2] & S[1] & S[0] & A[7];

endmodule