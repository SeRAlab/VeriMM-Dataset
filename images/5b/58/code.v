module top_module(
    input [3:0] A,
    input [3:0] B,
    input CI,
    output [3:0] C,
    output CO
);wire [3:0] sum;
wire carry;

// Full adder
assign sum[0] = A[0] ^ B[0] ^ CI;
assign carry = (A[0] & B[0]) | (A[0] & CI) | (B[0] & CI);
assign CO = (sum[0] > 3) ? 1 : 0;

assign sum[1] = A[1] ^ B[1] ^ carry;
assign carry = (A[1] & B[1]) | (A[1] & carry) | (B[1] & carry);
assign CO = (sum[1] > 3) ? 1 : CO;

assign sum[2] = A[2] ^ B[2] ^ carry;
assign carry = (A[2] & B[2]) | (A[2] & carry) | (B[2] & carry);
assign CO = (sum[2] > 3) ? 1 : CO;

assign sum[3] = A[3] ^ B[3] ^ carry;
assign CO = (sum[3] > 3) ? 1 : CO;

assign C = sum;

endmodule