module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + Cin;

    assign carry[0] = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));
    assign carry[1] = (A[1] & B[1]) | (sum[0] & (A[1] ^ B[1]));
    assign carry[2] = (A[2] & B[2]) | (sum[1] & (A[2] ^ B[2]));
    assign carry[3] = (A[3] & B[3]) | (sum[2] & (A[3] ^ B[3]));
    
    assign Cout = carry[3];
    assign S = sum;

endmodule