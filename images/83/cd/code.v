module top_module(
    Y,
    A_N,
    B_N,
    C,
    D
);// Module ports
    output Y;
    input  A_N;
    input  B_N;
    input  C;
    input  D;

    // Module supplies
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Local signals
    wire nand0_out;
    wire nand1_out;
    wire or0_out_Y;

    // Nand gates and an OR gate
    nand nand0 (nand0_out, D, C);
    nand nand1 (nand1_out, B_N, A_N);
    or   or0   (or0_out_Y, nand0_out, nand1_out);
    buf  buf0  (Y, or0_out_Y);

endmodule