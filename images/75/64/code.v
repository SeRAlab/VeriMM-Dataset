module top_module(
    output Y,
    input  A,
    input  B,
    input  C,
    input  D
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB;
    supply0 VNB;

    // Implement AND gates
    wire AB;
    wire CD;
    and and1 (AB, A, B);  // Fixed: Removed port names for instance
    and and2 (CD, C, D);  // Fixed: Removed port names for instance

    // Implement OR gate
    or or1 (Y, AB, CD);   // Fixed: Removed port names for instance

endmodule