module top_module(
    Y,
    A,
    B,
    C,
    D,
    EN
);output Y;
    input  A;
    input  B;
    input  C;
    input  D;
    input  EN;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    wire nand_out;

    // Use a built-in NAND gate instead
    nand (nand_out, A, B, C, D);

    assign Y = EN ? nand_out : 1'b1;

endmodule