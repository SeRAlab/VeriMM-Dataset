module top_module(
    input [15:0] A, B,
    output reg [15:0] SUM
);reg [15:0] carry;

always @(*) begin
    SUM[0] = A[0] ^ B[0] ^ carry[0];
    carry[1] = (A[0] & B[0]) | (A[0] & carry[0]) | (B[0] & carry[0]);
    SUM[1] = A[1] ^ B[1] ^ carry[1];
    carry[2] = (A[1] & B[1]) | (A[1] & carry[1]) | (B[1] & carry[1]);
    SUM[2] = A[2] ^ B[2] ^ carry[2];
    carry[3] = (A[2] & B[2]) | (A[2] & carry[2]) | (B[2] & carry[2]);
    SUM[3] = A[3] ^ B[3] ^ carry[3];
    carry[4] = (A[3] & B[3]) | (A[3] & carry[3]) | (B[3] & carry[3]);
    SUM[4] = A[4] ^ B[4] ^ carry[4];
    carry[5] = (A[4] & B[4]) | (A[4] & carry[4]) | (B[4] & carry[4]);
    SUM[5] = A[5] ^ B[5] ^ carry[5];
    carry[6] = (A[5] & B[5]) | (A[5] & carry[5]) | (B[5] & carry[5]);
    SUM[6] = A[6] ^ B[6] ^ carry[6];
    carry[7] = (A[6] & B[6]) | (A[6] & carry[6]) | (B[6] & carry[6]);
    SUM[7] = A[7] ^ B[7] ^ carry[7];
    carry[8] = (A[7] & B[7]) | (A[7] & carry[7]) | (B[7] & carry[7]);
    SUM[8] = A[8] ^ B[8] ^ carry[8];
    carry[9] = (A[8] & B[8]) | (A[8] & carry[8]) | (B[8] & carry[8]);
    SUM[9] = A[9] ^ B[9] ^ carry[9];
    carry[10] = (A[9] & B[9]) | (A[9] & carry[9]) | (B[9] & carry[9]);
    SUM[10] = A[10] ^ B[10] ^ carry[10];
    carry[11] = (A[10] & B[10]) | (A[10] & carry[10]) | (B[10] & carry[10]);
    SUM[11] = A[11] ^ B[11] ^ carry[11];
    carry[12] = (A[11] & B[11]) | (A[11] & carry[11]) | (B[11] & carry[11]);
    SUM[12] = A[12] ^ B[12] ^ carry[12];
    carry[13] = (A[12] & B[12]) | (A[12] & carry[12]) | (B[12] & carry[12]);
    SUM[13] = A[13] ^ B[13] ^ carry[13];
    carry[14] = (A[13] & B[13]) | (A[13] & carry[13]) | (B[13] & carry[13]);
    SUM[14] = A[14] ^ B[14] ^ carry[14];
    carry[15] = (A[14] & B[14]) | (A[14] & carry[14]) | (B[14] & carry[14]);
    SUM[15] = A[15] ^ B[15] ^ carry[15];
end

endmodule