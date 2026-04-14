module top_module(
    input A,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Y
);wire inv1_out;
    wire inv2_out;
    wire inv3_out;
    wire inv4_out;

    assign inv1_out = ~VGND;
    assign inv2_out = ~VNB;
    assign inv3_out = ~VPB;
    assign inv4_out = ~VPWR;

    assign Y = (A & inv1_out & inv2_out & inv3_out & inv4_out);

endmodule