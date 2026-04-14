module top_module(
    input [7:0] A,
    input [7:0] B,
    output reg [7:0] S,
    output reg C_out
);reg C;

    always @* begin
        S[0] = A[0] ^ B[0] ^ C;
        C = (A[0] & B[0]) | (A[0] & C) | (B[0] & C);
        S[1] = A[1] ^ B[1] ^ C;
        C = (A[1] & B[1]) | (A[1] & C) | (B[1] & C);
        S[2] = A[2] ^ B[2] ^ C;
        C = (A[2] & B[2]) | (A[2] & C) | (B[2] & C);
        S[3] = A[3] ^ B[3] ^ C;
        C = (A[3] & B[3]) | (A[3] & C) | (B[3] & C);
        S[4] = A[4] ^ B[4] ^ C;
        C = (A[4] & B[4]) | (A[4] & C) | (B[4] & C);
        S[5] = A[5] ^ B[5] ^ C;
        C = (A[5] & B[5]) | (A[5] & C) | (B[5] & C);
        S[6] = A[6] ^ B[6] ^ C;
        C = (A[6] & B[6]) | (A[6] & C) | (B[6] & C);
        S[7] = A[7] ^ B[7] ^ C;
        C_out = C;
    end

endmodule