module top_module(
    output Y,
    input A1,
    input A2,
    input B1,
    input C1,
    input D1,
    input VPWR,
    input VGND
);wire A1n, A2n, B1n, C1n, D1n, VPWRn, VGNDn;
    assign A1n = ~A1;
    assign A2n = ~A2;
    assign B1n = ~B1;
    assign C1n = ~C1;
    assign D1n = ~D1;
    assign VPWRn = ~VPWR;
    assign VGNDn = ~VGND;

    wire Y1, Y2, Y3, Y4;
    nand n1(Y1, A1n, A2n);
    nand n2(Y2, A1, A2n);
    nand n3(Y3, A1n, A2);
    nand n4(Y4, A1, A2);

    wire Y5, Y6, Y7, Y8;
    nand n5(Y5, Y1, B1n);
    nand n6(Y6, Y2, B1);
    nand n7(Y7, Y3, B1);
    nand n8(Y8, Y4, B1n);

    wire Y9, Y10, Y11, Y12;
    nand n9(Y9, Y5, C1);
    nand n10(Y10, Y6, C1);
    nand n11(Y11, Y7, C1n);
    nand n12(Y12, Y8, C1n);

    wire Y13, Y14, Y15, Y16;
    nand n13(Y13, Y9, D1);
    nand n14(Y14, Y10, D1n);
    nand n15(Y15, Y11, D1);
    nand n16(Y16, Y12, D1n);

    wire Y17, Y18, Y19, Y20;
    nand n17(Y17, Y13, VPWRn);
    nand n18(Y18, Y14, VPWR);
    nand n19(Y19, Y15, VPWRn);
    nand n20(Y20, Y16, VPWR);

    wire Y21, Y22, Y23, Y24;
    nand n21(Y21, Y17, VGND);
    nand n22(Y22, Y18, VGNDn);
    nand n23(Y23, Y19, VGND);
    nand n24(Y24, Y20, VGNDn);

    wire Y25, Y26, Y27, Y28;
    nand n25(Y25, Y21, Y22);
    nand n26(Y26, Y23, Y24);
    nand n27(Y27, Y25, Y26);
    nand n28(Y28, Y27, Y27);

    assign Y = Y28;

endmodule