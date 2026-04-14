module top_module(
    input A,
    input B,
    input C,
    input D,
    output Y,
    input VPB,
    input VPWR,
    input VGND,
    input VNB
);wire nand1_out, nand2_out, nand3_out;

    // Simple NAND gate implementation
    assign nand1_out = ~(A & B);
    assign nand2_out = ~(C & D);
    assign nand3_out = ~(nand1_out & nand2_out);
    assign Y = ~(nand3_out & nand3_out); // Y = NAND(nand3_out, nand3_out)

endmodule