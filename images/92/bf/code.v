module top_module(
    A, B, C, D,
    Sel0, Sel1,
    Y
);output Y;
    input A, B, C, D;
    input Sel0, Sel1;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;

    wire AB, CD, AC, BD, Y0, Y1;

    // Use regular NAND gate definition instead of the unknown sky130_fd_sc_hs__nand2b
    wire nand2_out1, nand2_out2, nand2_out3, nand2_out4, nand2_out5, nand2_out6, nand2_out7;
    
    // NAND gate descriptions (replace with actual NAND gate implementation or primitives)
    assign nand2_out1 = ~(A & B);
    assign nand2_out2 = ~(C & D);
    assign nand2_out3 = ~(A & C);
    assign nand2_out4 = ~(B & D);
    assign nand2_out5 = ~(nand2_out1 & nand2_out2);
    assign nand2_out6 = ~(nand2_out3 & nand2_out4);
    assign Y = ~(nand2_out5 & nand2_out6);

    // Implement multiplexer logic using the defined NAND gates
    wire mux_out0, mux_out1;
    assign mux_out0 = ~(AB & Sel0) | ~(CD & ~Sel0);
    assign mux_out1 = ~(AC & Sel1) | ~(BD & ~Sel1);
    assign Y = ~(mux_out0 & mux_out1);

endmodule