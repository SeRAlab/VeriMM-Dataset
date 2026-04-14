module top_module(
    input  wire [63:0] x,
    output wire [3:0] r0,
    output wire [3:0] r1,
    output wire [3:0] r2,
    output wire [3:0] r3,
    output wire [3:0] r4,
    output wire [3:0] r5,
    output wire [3:0] r6,
    output wire [3:0] r7,
    output wire [3:0] r8,
    output wire [3:0] r9,
    output wire [3:0] rA,
    output wire [3:0] rB,
    output wire [3:0] rC,
    output wire [3:0] rD,
    output wire [3:0] rE,
    output wire [3:0] rF
);assign {rF, rE, rD, rC, rB, rA, r9, r8, r7, r6, r5, r4, r3, r2, r1, r0} = x;endmodule