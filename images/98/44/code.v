module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] S
);wire [3:0] C; //carry bits
wire [3:0] X; //sum bits

//full adder for bit 0
xor (X[0], A[0], B[0]);
and (C[0], A[0], B[0]);

//full adder for bit 1
xor (X[1], A[1], B[1], C[0]);
and (C[1], (A[1] & B[1]), (A[1] & C[0]), (B[1] & C[0]));

//full adder for bit 2
xor (X[2], A[2], B[2], C[1]);
and (C[2], (A[2] & B[2]), (A[2] & C[1]), (B[2] & C[1]));

//full adder for bit 3
xor (X[3], A[3], B[3], C[2]);
and (C[3], (A[3] & B[3]), (A[3] & C[2]), (B[3] & C[2]));

assign S = X;
endmodule