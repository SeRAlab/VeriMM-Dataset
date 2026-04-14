module top_module(
    input A,
    input B,
    input C,
    input D,
    output [15:0] Y
);wire [3:0] nA, nB, nC, nD;
wire [15:0] stage1, stage2;

assign nA = ~A;
assign nB = ~B;
assign nC = ~C;
assign nD = ~D;

// Stage 1
// First row of NAND gates
assign stage1[0] = nA & nB & nC & nD;
assign stage1[1] = nA & nB & nC & D;
assign stage1[2] = nA & nB & C & nD;
assign stage1[3] = nA & nB & C & D;
assign stage1[4] = nA & B & nC & nD;
assign stage1[5] = nA & B & nC & D;
assign stage1[6] = nA & B & C & nD;
assign stage1[7] = nA & B & C & D;

// Stage 2
// Second row of NAND gates
assign stage2[0] = stage1[0] & stage1[1] & stage1[2] & stage1[3];
assign stage2[1] = stage1[0] & stage1[1] & stage1[4] & stage1[5];
assign stage2[2] = stage1[0] & stage1[2] & stage1[4] & stage1[6];
assign stage2[3] = stage1[1] & stage1[3] & stage1[5] & stage1[7];
assign stage2[4] = stage1[2] & stage1[3] & stage1[6] & stage1[7];
assign stage2[5] = stage1[4] & stage1[5] & stage1[6] & stage1[7];

// Output
assign Y = stage2;

endmodule