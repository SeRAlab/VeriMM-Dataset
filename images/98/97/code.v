module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);wire [3:0] sum;

    assign sum[0] = A[0] ^ B[0] ^ Cin;
    assign sum[1] = A[1] ^ B[1] ^ (sum[0] & Cin);
    assign sum[2] = A[2] ^ B[2] ^ (sum[1] & sum[0]);
    assign sum[3] = A[3] ^ B[3] ^ (sum[2] & sum[1]);

    assign Cout = (sum[3] & sum[2]) | (sum[3] & sum[1]) | (sum[2] & sum[1] & Cin);
    assign S = sum;

endmodule