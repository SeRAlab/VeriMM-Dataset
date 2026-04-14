module top_module(
    Y,
    A,
    B,
    C,
    D,
    VPWR,
    VGND,
    VPB,
    VNB
);output Y;
    input A;
    input B;
    input C;
    input D;
    input VPWR;
    input VGND;
    input VPB;
    input VNB;

    wire nand1_out;
    wire nand2_out;
    wire nand3_out;

    // Define a behavioral NAND gate
    assign nand1_out = ~(A & B);
    assign nand2_out = ~(C & D);
    assign nand3_out = ~(nand1_out & nand2_out);

    // Final NAND output
    assign Y = ~(nand3_out & VGND & VPWR);

endmodule