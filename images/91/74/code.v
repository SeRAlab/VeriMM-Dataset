module top_module(
    input A,
    input B,
    input C,
    input D,
    output [15:0] Y
);wire nA, nB, nC, nD;

assign nA = ~A;
assign nB = ~B;
assign nC = ~C;
assign nD = ~D;

assign Y[0]  = nA & nB & nC & nD;
assign Y[1]  = nA & nB & nC & D;
assign Y[2]  = nA & nB & C & nD;
assign Y[3]  = nA & nB & C & D;
assign Y[4]  = nA & C & nB & nD;
assign Y[5]  = nA & C & nB & D;
assign Y[6]  = nA & C & D & nB;
assign Y[7]  = nA & C & D & D;
assign Y[8]  = A & nB & nC & nD;
assign Y[9]  = A & nB & nC & D;
assign Y[10] = A & nB & C & nD;
assign Y[11] = A & nB & C & D;
assign Y[12] = A & C & nB & nD;
assign Y[13] = A & C & nB & D;
assign Y[14] = A & C & D & nB;
assign Y[15] = A & C & D & D;

endmodule