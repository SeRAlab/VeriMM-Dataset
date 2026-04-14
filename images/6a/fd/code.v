module top_module(
    A,
    B,
    C,
    D,
    VPWR,
    VGND,
    VPB,
    VNB,
    X
);input A, B, C, D, VPWR, VGND, VPB, VNB;
    output X;

    wire w1, w2;

    // Instead of the missing sky130 module, using the built-in XOR operator
    assign w1 = A ^ B; // w1 is the output of A XOR B
    assign w2 = C ^ D; // w2 is the output of C XOR D
    assign X = w1 ^ w2; // X is the output of w1 XOR w2

endmodule