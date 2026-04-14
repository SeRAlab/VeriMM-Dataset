module top_module(
    input RESET_B,
    input D,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output Q,
    output Q_N,
    input GATE
);wire D_N;
    wire Q_PRE;
    wire Q_N_PRE;
    wire SET_B; // Added for usage since it was referenced.

    assign D_N = ~D;

    // Using primitive NAND gates instead of nand2
    wire nand1_out, nand2_out, nand3_out, nand4_out;
    assign nand1_out = ~(D_N & RESET_B);
    assign nand2_out = ~(nand1_out & SET_B);
    assign nand3_out = ~(D & RESET_B);
    assign nand4_out = ~(nand3_out & SET_B);

    assign Q_PRE = nand2_out;
    assign Q_N_PRE = nand4_out;

    assign Q = Q_PRE;
    assign Q_N = Q_N_PRE;

endmodule