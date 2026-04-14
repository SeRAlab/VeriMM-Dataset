module sky130_fd_sc_hd__fa(
    input A,
    input B,
    input CIN,
    input VPWR,
    input VGND,
    input VPB,
    input VNB,
    output COUT,
    output SUM
);

    wire W1;
    wire W2;
    wire W3;

    // XOR gates
    assign W1 = A ^ B;
    assign SUM = W1 ^ CIN;

    // AND gates
    assign W2 = A & B;
    assign W3 = CIN & W1;

    // OR gate
    assign COUT = W2 | W3;

endmodule