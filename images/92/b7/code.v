module top_module(
    Y1,
    Y2,
    A,
    B,
    C,
    D,
    VPWR,
    VGND,
    VPB,
    VNB
);output Y1;
    output Y2;
    input A;
    input B;
    input C;
    input D;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire nand1, nand2, nand3, nand4, nand5, nand6;

    // Use a standard nand gate instead of sky130_fd_sc_ls__nand2
    assign nand1 = ~(A & B);
    assign nand2 = ~(C & D);
    assign nand3 = ~(nand1 & nand2);
    assign nand4 = ~(C & VGND);
    assign nand5 = ~(D & VGND);
    assign nand6 = ~(nand4 & nand5);

    assign Y1 = ~(nand3 & VGND);
    assign Y2 = ~(nand3 & nand6);

endmodule