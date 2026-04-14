module top_module(
    input  A,
    input  B,
    input  C,
    input  D,
    output X
);assign X = A & B & C & D;

    // Voltage supply signals
    supply1 VPWR;
    supply0 VGND;
    supply1 VPB ;
    supply0 VNB ;

endmodule