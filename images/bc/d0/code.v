module top_module(
    input [3:0] A,
    input [3:0] B,
    output Cout,
    output [3:0] S
);wire [3:0] sum;
    wire c_in;
    wire [3:0] carry;

    // Full adder logic
    assign sum[0] = A[0] ^ B[0] ^ c_in;
    assign carry[0] = (A[0] & B[0]) | (c_in & (A[0] ^ B[0]));

    assign sum[1] = A[1] ^ B[1] ^ carry[0];
    assign carry[1] = (A[1] & B[1]) | (carry[0] & (A[1] ^ B[1]));

    assign sum[2] = A[2] ^ B[2] ^ carry[1];
    assign carry[2] = (A[2] & B[2]) | (carry[1] & (A[2] ^ B[2]));

    assign sum[3] = A[3] ^ B[3] ^ carry[2];
    assign Cout = (A[3] & B[3]) | (carry[2] & (A[3] ^ B[3]));

    assign S = sum;

endmodule