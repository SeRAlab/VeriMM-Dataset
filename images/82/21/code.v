module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output reg [3:0] S,
    output reg Cout
);always @*
    begin
        S[0] = A[0] ^ B[0] ^ Cin;
        S[1] = A[1] ^ B[1] ^ ((A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin));
        S[2] = A[2] ^ B[2] ^ ((A[1] & B[1]) | (A[1] & A[0] & B[0]) | (A[1] & B[0] & Cin) | (B[1] & A[0] & Cin));
        S[3] = A[3] ^ B[3] ^ ((A[2] & B[2]) | (A[2] & A[1] & B[1]) | (A[2] & B[1] & A[0]) | (A[2] & B[0] & Cin) | (B[2] & A[1] & A[0]) | (B[2] & B[1] & Cin));
        Cout = ((A[3] & B[3]) | (A[3] & A[2] & B[2]) | (A[3] & B[2] & B[1]) | (A[3] & B[1] & B[0]) | (A[2] & B[2] & Cin) | (A[2] & A[1] & B[1] & Cin) | (A[2] & B[1] & B[0] & Cin) | (A[1] & B[1] & B[0] & Cin));
    end

endmodule