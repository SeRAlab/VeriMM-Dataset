module top_module(
    Y,
    A1,
    A2,
    B1,
    B2
);output Y;
    input  A1;
    input  A2;
    input  B1;
    input  B2;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Instantiate a valid logic gate instead of the missing sky130_fd_sc_ms__o22ai
    wire and1, and2, nand1, nand2;

    assign and1 = A1 & A2;
    assign and2 = B1 & B2;
    assign nand1 = ~(B1 & B2);

    assign Y = (and1 | and2 & nand1);

endmodule