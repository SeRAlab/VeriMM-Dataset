module top_module(
    input A,
    input B,
    input VPWR,
    input VGND,
    inout VPB,
    inout VNB,
    output Y
);wire A_inv, B_inv, AB_and, AB_nand, AB_nor, AB_or, AB_xor;

    assign A_inv = ~A;
    assign B_inv = ~B;
    assign AB_and = A & B;
    assign AB_nand = ~(A & B);
    assign AB_nor = ~(A | B);
    assign AB_or = A | B;
    assign AB_xor = A ^ B;

    assign VPB = VGND & AB_nand & AB_nor;
    assign VNB = VPWR & AB_nand & AB_or;

    assign Y = ~(AB_xor & VPB & VNB);

endmodule