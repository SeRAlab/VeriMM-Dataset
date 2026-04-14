module top_module(
    output X,
    input  A,
    input  B,
    input  C
);// Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

    // Instantiate OR3 gate
    wire N1, N2;

    or or_gate1 (N1, A, B);
    or or_gate2 (X, N1, C);

endmodule