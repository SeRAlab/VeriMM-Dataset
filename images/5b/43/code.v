module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg [3:0] SUM
);always @* begin
        SUM[0] = A[0] ^ B[0];
        SUM[1] = (A[1] ^ B[1]) ^ (A[0] & B[0]);
        SUM[2] = (A[2] ^ B[2]) ^ ((A[1] & B[1]) | (A[0] & B[0]));
        SUM[3] = (A[3] ^ B[3]) ^ ((A[2] & B[2]) | (A[1] & B[1]) | (A[0] & B[0]));
    end

endmodule