module adder_32bit(
    input [32:1] A,
    input [32:1] B,
    output [32:1] S,
    output C32
);

wire C16;

cla_16bit u0 (
    .A(A[16:1]),
    .B(B[16:1]),
    .C0(1'b0),
    .S(S[16:1]),
    .C16(C16)
);

cla_16bit u1 (
    .A(A[32:17]),
    .B(B[32:17]),
    .C0(C16),
    .S(S[32:17]),
    .C16(C32)
);

endmodule

module cla_16bit(
    input [16:1] A,
    input [16:1] B,
    input C0,
    output [16:1] S,
    output C16
);

wire [16:0] G, P, C;

assign G = {A & B, 1'b0};
assign P = {A ^ B, 1'b0};

assign C[0] = C0;
assign C[1] = G[1] | (P[1] & C[0]);
assign C[2] = G[2] | (P[2] & C[1]);
assign C[3] = G[3] | (P[3] & C[2]);
assign C[4] = G[4] | (P[4] & C[3]);
assign C[5] = G[5] | (P[5] & C[4]);
assign C[6] = G[6] | (P[6] & C[5]);
assign C[7] = G[7] | (P[7] & C[6]);
assign C[8] = G[8] | (P[8] & C[7]);
assign C[9] = G[9] | (P[9] & C[8]);
assign C[10] = G[10] | (P[10] & C[9]);
assign C[11] = G[11] | (P[11] & C[10]);
assign C[12] = G[12] | (P[12] & C[11]);
assign C[13] = G[13] | (P[13] & C[12]);
assign C[14] = G[14] | (P[14] & C[13]);
assign C[15] = G[15] | (P[15] & C[14]);
assign C[16] = G[16] | (P[16] & C[15]);

assign S = P[16:1] ^ C[15:0];
assign C16 = C[16];

endmodule
