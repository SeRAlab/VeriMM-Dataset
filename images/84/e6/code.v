module top_module(
    input [3:0] A, B, Cin,
    input Cin0, CLK,
    output [3:0] S,
    output Cout
);wire [3:0] sum;
    wire [3:0] carry;

    assign sum = A + B + Cin;

    assign carry[0] = Cin0 ? (A[0] & B[0]) : (A[0] | B[0]);
    assign carry[1] = (sum[0] & Cin) | (A[1] & B[1]) | (Cin & A[1]) | (Cin & B[1]);
    assign carry[2] = (sum[1] & carry[1]) | (sum[0] & Cin & A[1]) | (sum[0] & Cin & B[1]) | (A[2] & B[2] & Cin) | (A[2] & B[2] & carry[1]) | (A[2] & Cin & B[1]) | (B[2] & Cin & A[1]);
    assign carry[3] = (sum[2] & carry[2]) | (sum[1] & Cin & A[2]) | (sum[1] & Cin & B[2]) | (A[3] & B[3] & Cin) | (A[3] & B[3] & carry[2]) | (A[3] & Cin & B[2]) | (B[3] & Cin & A[2]);

    assign S = sum;
    assign Cout = carry[3];

endmodule