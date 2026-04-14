module top_module(
    input  A1,
    input  A2,
    input  A3,
    input  B1,
    input  C1,
    output Y,

    input  VPB,
    input  VPWR,
    input  VGND,
    input  VNB
);wire a2_and_a3;
    wire b1_and_c1;

    assign a2_and_a3 = A2 & A3;
    assign b1_and_c1 = B1 & C1;

    assign Y = (A1) ? 1'b1 : ((a2_and_a3 | b1_and_c1) ? 1'b1 : 1'b0);

endmodule