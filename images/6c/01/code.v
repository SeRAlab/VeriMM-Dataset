module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] S,
    output reg C
);reg carry;

always @* begin
    S[0] = A[0] ^ B[0] ^ carry;
    carry = (A[0] & B[0]) | (A[0] & carry) | (B[0] & carry);
    S[1] = A[1] ^ B[1] ^ carry;
    carry = (A[1] & B[1]) | (A[1] & carry) | (B[1] & carry);
    S[2] = A[2] ^ B[2] ^ carry;
    carry = (A[2] & B[2]) | (A[2] & carry) | (B[2] & carry);
    S[3] = A[3] ^ B[3] ^ carry;
    C = carry;
end

endmodule